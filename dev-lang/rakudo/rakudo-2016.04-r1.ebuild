# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit java-pkg-2

DESCRIPTION="A compiler for the Perl 6 programming language"
HOMEPAGE="http://rakudo.org"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/rakudo/${PN}.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="${HOMEPAGE}/downloads/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Artistic-2"
SLOT="0"
# TODO: add USE="javascript" once that's usable in nqp
IUSE="clang java +moar test"

RDEPEND="~dev-lang/nqp-${PV}:=[java=,moar=,clang=]"
DEPEND="${RDEPEND}
	clang? ( sys-devel/clang )
	>=dev-lang/perl-5.10"

REQUIRED_USE="|| ( java moar )"
PATCHES=( "${FILESDIR}/${PN}-2016.04-Makefile.in.patch" )

pkg_pretend() {
	if has_version dev-lang/rakudo && use java; then
		die "Rakudo is known to fail compilation with the jvm backend if it's already installed."
	fi
}

pkg_setup() {
	use java && java-pkg-2_pkg_setup
}

src_prepare() {
	eapply "${PATCHES[@]}"

	# yup, this is ugly. but emake doesn't respect DESTDIR.
	for i in Moar JVM; do
		echo "DESTDIR   = ${D}" > "${T}/Makefile-${i}.in" || die
		cat "${S}/tools/build/Makefile-${i}.in" >> "${T}/Makefile-${i}.in" || die
		mv "${T}/Makefile-${i}.in" "${S}/tools/build/Makefile-${i}.in" || die
	done

	eapply_user
	use java && java-pkg-2_src_prepare
}

src_configure() {
	local backends
	use java && backends+="jvm,"
	use moar && backends+="moar,"
	local myargs=( "--prefix=/usr"
		"--sysroot=/"
		"--sdkroot=/"
		"--make-install"
		"--sdkroot=/"
		"--backends=${backends}"
	)
	perl Configure.pl "${myargs[@]}"
}

src_compile() {
	emake DESTDIR="${D}"
}

src_test() {
	export RAKUDO_PRECOMP_PREFIX=$(mktemp -d)
	default
}

src_install() {
	emake DESTDIR="${D}" install
}
