# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-opt-2

DESCRIPTION="A compiler for the Perl 6 programming language"
HOMEPAGE="https://rakudo.org"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/rakudo/${PN}.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://rakudo.perl6.org/downloads/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Artistic-2"
SLOT="0"
# TODO: add USE="javascript" once that's usable in nqp
IUSE="clang java +moar test"
REQUIRED_USE="|| ( java moar )"

CDEPEND="~dev-lang/nqp-${PV}:${SLOT}=[java?,moar?,clang=]"
RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.7 )"
DEPEND="${CDEPEND}
	clang? ( sys-devel/clang )
	java? ( >=virtual/jdk-1.7 )
	>=dev-lang/perl-5.10"

pkg_pretend() {
	if has_version dev-lang/rakudo; then
		ewarn "Rakudo is known to fail compilation/installation with Rakudo"
		ewarn "already being installed. So if it fails, try unmerging dev-lang/rakudo,"
		ewarn "then do a new installation."
		ewarn "(see Bug #584394)"
	fi
}

src_configure() {
	local backends
	use moar && backends+="moar,"
	use java && backends+="jvm"

	local myargs=(
		"--prefix=/usr"
		"--sysroot=/"
		"--sdkroot=/"
		"--backends=${backends}"
	)

	perl Configure.pl "${myargs[@]}" || die

	if use java; then
		NQP=$(java-pkg_getjars --with-dependencies nqp)
	fi
}

src_compile() {
	emake DESTDIR="${D}" NQP_JARS="${NQP}" BLD_NQP_JARS="${NQP}"
}

src_install() {
	emake DESTDIR="${D}" NQP_JARS="${NQP}" BLD_NQP_JARS="${NQP}" install
}

src_test() {
	RAKUDO_PRECOMP_PREFIX=$(mktemp -d) default
}
