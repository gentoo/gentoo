# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rakudo.eclass
# @MAINTAINER:
# amano.kenji <amano.kenji@proton.me>
# @BLURB: An eclass for raku modules

EXPORT_FUNCTIONS src_compile src_test src_install

RDEPEND="dev-lang/rakudo:="
BDEPEND="dev-lang/rakudo"
case "${CATEGORY}/${PN}" in
	dev-raku/App-Prove6|dev-raku/Getopt-Long|dev-raku/TAP)
		;;
	*)
		BDEPEND="${BDEPEND} test? ( dev-raku/App-Prove6 )"
		IUSE="test"
		RESTRICT="!test? ( test )"
		;;
esac

# @FUNCTION: rakudo_symlink_bin
# @USAGE: <executable-file-name-in-/usr/share/perl6/vendor/bin>
# @DESCRIPTION:
# Make a symlink to /usr/share/perl6/vendor/bin/executable in /usr/bin
rakudo_symlink_bin() {
	dosym "../share/perl6/vendor/bin/$1" "/usr/bin/$1" || die
}

rakudo_src_compile() {
	local -x RAKUDO_RERESOLVE_DEPENDENCIES=0
	"${BROOT}"/usr/share/perl6/core/tools/install-dist.raku --only-build --from=. \
	|| die
}

rakudo_src_test() {
	prove6 --lib t/ || die
}

rakudo_src_install() {
	einstalldocs
	local -x RAKUDO_RERESOLVE_DEPENDENCIES=0
	"${BROOT}"/usr/share/perl6/core/tools/install-dist.raku \
	--to="${D}/usr/share/perl6/vendor" --for=vendor --from=. --build=False \
	|| die
}
