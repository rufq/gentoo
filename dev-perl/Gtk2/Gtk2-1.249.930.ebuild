# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=XAOC
DIST_VERSION=1.24993
inherit virtualx perl-module

DESCRIPTION="Perl bindings for GTK2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	x11-libs/gtk+:2
	>=dev-perl/Cairo-1
	>=dev-perl/glib-perl-1.280.0
	>=dev-perl/Pango-1.220.0

"
DEPEND="
	x11-libs/gtk+:2
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/ExtUtils-Depends-0.300.0
	>=dev-perl/ExtUtils-PkgConfig-1.30.0
	test? ( x11-libs/gdk-pixbuf[jpeg] )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.249.930-skip-pixbuf-test.patch
)

src_test() {
	virtx perl-module_src_test
}
