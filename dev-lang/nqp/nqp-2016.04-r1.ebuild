# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit java-pkg-2

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/perl6/${PN}.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/perl6/${PN}/tarball/${PV} -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

DESCRIPTION="Not Quite Perl, a Perl 6 bootstrapping compiler"
HOMEPAGE="http://rakudo.org/"

LICENSE="Artistic-2"
SLOT="0"
IUSE="doc clang java +moar +system-libs test"
REQUIRED_USE="|| ( java moar )"

RDEPEND="java? ( >=virtual/jre-1.7:*
		system-libs? (
			dev-java/asm:4
			dev-java/jline:0
		)
	)
	moar? ( ~dev-lang/moarvm-${PV}[clang=] )
	dev-libs/libffi"
DEPEND="${RDEPEND}
	clang? ( sys-devel/clang )
	java? ( >=virtual/jdk-1.7:* )
	dev-lang/perl"
PATCHES=( "${FILESDIR}/enable-external-jars.patch" )

pkg_setup() {
	use java && java-pkg-2_pkg_setup
}

src_prepare() {
	eapply "${PATCHES[@]}"
	eapply_user
	use java && java-pkg-2_src_prepare
}

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
	else
		unpack ${A}
		mv "${WORKDIR}/perl6-nqp-"* "${WORKDIR}/${P}" || die
	fi
}

src_configure() {
	local backends
	use java && backends+="jvm,"
	use moar && backends+="moar"
	local myconfargs=(
		"--backend=${backends}"
		"--prefix=/usr" )

	# 2016.04 doesn't like our jna-3.4.1
	# keep testing against it
	use system-libs && myconfargs+=(
		"--with-asm=$(echo $(java-pkg_getjars asm-4) | tr : '\n' | grep '/asm\.jar$')"
		"--with-asm-tree=$(echo $(java-pkg_getjars asm-4) | tr : '\n' | grep '/asm-tree\.jar$')"
		"--with-jline=$(echo $(java-pkg_getjars jline) | tr : '\n' | grep '/jline\.jar$')" )

	perl Configure.pl "${myconfargs[@]}" || die
}

src_compile() {
	MAKEOPTS=-j1 emake
}

src_test() {
	MAKEOPTS=-j1 emake test
}

src_install() {
	emake DESTDIR="${ED}" install || die

	dodoc CREDITS README.pod || die

	if use doc; then
		dodoc -r docs/* || die
	fi
}
