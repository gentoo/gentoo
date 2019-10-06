# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${P/-utils}

DESCRIPTION="Set of utilities to simplify various dns(sec) tasks"
HOMEPAGE="http://www.nlnetlabs.nl/projects/ldns/"
SRC_URI="http://www.nlnetlabs.nl/downloads/ldns/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="+dane ecdsa ed25519 ed448 examples gost ssl"

REQUIRED_USE="
	ecdsa? ( ssl )
	ed25519? ( ssl )
	ed448? ( ssl )
	dane? ( ssl )
	gost? ( ssl )
"

DEPEND=">=net-libs/ldns-${PV}[dane?,ecdsa?,ed25519?,ed448?,gost?]
	examples? ( net-libs/libpcap )"
RDEPEND="${DEPEND}"

RESTRICT="test"

S=${WORKDIR}/${MY_P}

src_configure() {
	# >=openssl-1.1.0 required for dane-ta
	if has_version "<dev-libs/openssl-1.1.0" || has_version dev-libs/libressl; then
		local dane_ta_usage="--disable-dane-ta-usage"
	else
		local dane_ta_usage=""
	fi

	ECONF_SOURCE=${S} \
	econf \
		--with-drill \
		$(use_with ssl) \
		$(use_with examples) \
		$(use_enable dane) \
		$(use_enable ecdsa) \
		$(use_enable ed25519) \
		$(use_enable ed448) \
		$(use_enable gost) \
		$(use_enable ssl sha2) \
		$dane_ta_usage
}

src_compile() {
	default
}

src_install() {
	#cd "${S}"/drill
	emake DESTDIR="${D}" install-drill
	dodoc drill/{ChangeLog.22-nov-2005,README,REGRESSIONS}

	if use examples; then
		emake DESTDIR="${D}" install-examples
		newdoc examples/README README.examples
	fi
}
