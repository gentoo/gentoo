# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

MY_PV="$(ver_rs 1- '')"
DESCRIPTION="Cryptographic primitives library for Objective Caml"
HOMEPAGE="https://github.com/xavierleroy/cryptokit"
SRC_URI="https://github.com/xavierleroy/cryptokit/archive/release${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release${MY_PV}"

LICENSE="LGPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ppc ~x86"
IUSE="cpu_flags_x86_aes +ocamlopt test zlib"
REQUIRED_USE="test? ( ocamlopt )"
RESTRICT="!test? ( test )"

# We can't use mpir on zarith
# (until it gains mpz_powm_sec?)
# bug #750740
DEPEND="
	dev-ml/dune-configurator
	dev-ml/zarith:=[-mpir]
	zlib? ( >=sys-libs/zlib-1.1 )
"
RDEPEND="${DEPEND}"

DOCS=( "Changes" "README.txt" "AUTHORS.txt" )

src_configure() {
	# Don't build in src_configure
	sed -i -e 's:exit (Sys.command "dune build @configure --release")::' configure || die

	# It's not autotools (or even close), it's a Dune wrapper.
	./configure \
		$(use_enable cpu_flags_x86_aes hardwaresupport) \
		$(use_enable zlib) \
		|| die
}

pkg_postinst() {
	elog ""
	elog "This library uses the /dev/random device to generate "
	elog "random data and RSA keys.  The device should either be"
	elog "built into the kernel or provided as a module. An"
	elog "alternative is to use the Entropy Gathering Daemon"
	elog "(http://egd.sourceforge.net).  Please note that the"
	elog "remainder of the library will still work even in the"
	elog "absence of a one of these sources of randomness."
	elog ""
}

src_test() {
	echo ""
	einfo "You must have either /dev/random or the Entropy Gathering"
	einfo "Daemon (EGD) for this test to succeed!"
	echo ""

	dune_src_test
}
