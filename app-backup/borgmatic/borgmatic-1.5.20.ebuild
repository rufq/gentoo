# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1 systemd

DESCRIPTION="Automatically create, prune and verify backups with borgbackup"
HOMEPAGE="https://torsion.org/borgmatic/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv"

# borg is called as an external tool, hence no pythonic stuff
RDEPEND="app-backup/borgbackup
	$(python_gen_cond_dep '
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		<dev-python/ruamel-yaml-0.18.0[${PYTHON_USEDEP}]
	')"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			>=dev-python/flexmock-0.10.10[${PYTHON_USEDEP}]
		')
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.1-no_test_coverage.patch
	"${FILESDIR}"/${PN}-1.5.16-systemd_service_bin_path.patch
)

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# Unlike the other two test files in integration/commands, which use the
	# relevant modules' respective APIs, test_borgmatic.py tries to call the
	# 'borgmatic' executable - which by the time we execute src_test will
	# not have been created yet. Adding --install to distutils_enable_tests would
	# likely take care of this - but between the aforementioned behaviour
	# inconsistency and the fact the only test run from this file as of version
	# 1.5.13 is the parsing of contents of 'borgmatic --version', just skip it.
	rm -f "${S}"/tests/integration/commands/test_borgmatic.py
}

src_install() {
	distutils-r1_src_install
	systemd_dounit sample/systemd/borgmatic.{service,timer}
	keepdir /etc/borgmatic
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "To generate a sample configuration file, run:"
		elog "    generate-borgmatic-config"
	fi
	elog
	elog "Systemd users wishing to periodically run borgmatic can use the provided timer and service units."
}
