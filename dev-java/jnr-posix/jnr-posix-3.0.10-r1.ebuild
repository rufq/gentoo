# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test"
JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} javadoc"
JAVA_ANT_ENCODING="UTF-8"

EANT_EXTRA_ARGS="-Dmaven.build.finalName=${PN}"
EANT_GENTOO_CLASSPATH="jnr-constants,jnr-ffi-2"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Lightweight cross-platform POSIX emulation layer for Java"
HOMEPAGE="https://github.com/jnr/jnr-posix"
SRC_URI="https://github.com/jnr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( CPL-1.0 GPL-2 LGPL-2.1 )"
SLOT="3.0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"

CDEPEND="dev-java/jnr-constants:0
	dev-java/jnr-ffi:2"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/ant-junit4:0
		dev-java/junit:4
	)"

src_prepare() {
	default

	cp "${FILESDIR}"/${PN}_maven-build.xml build.xml || die
}

src_test() {
	ANT_TASKS="ant-junit4" eant test -DJunit.present=true
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	dodoc README.txt

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
