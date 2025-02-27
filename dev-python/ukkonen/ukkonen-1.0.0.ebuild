# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Implementation of bounded Levenshtein distance (Ukkonen)"
HOMEPAGE="
	https://pypi.org/project/ukkonen/
	https://github.com/asottile/ukkonen/"
SRC_URI="
	https://github.com/asottile/ukkonen/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/cffi[${PYTHON_USEDEP}]
	' 'python*')"
BDEPEND=${RDEPEND}

distutils_enable_tests pytest
