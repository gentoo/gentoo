# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P=${P/-utils}

DESCRIPTION="Set of utilities to simplify various dns(sec) tasks"
HOMEPAGE="http://www.nlnetlabs.nl/projects/ldns/"
SRC_URI="http://www.nlnetlabs.nl/downloads/ldns/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="+dane ecdsa examples gost ssl"

REQUIRED_USE="
	ecdsa? ( ssl )
	dane? ( ssl )
	gost? ( ssl )
"

DEPEND=">=net-libs/ldns-${PV}[dane?,ecdsa?,gost?]
	examples? ( net-libs/libpcap )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	cd "${S}"/drill
	econf $(use_with ssl)

	if use examples; then
		cd "${S}"/examples
		econf \
			$(use_enable dane) \
			$(use_enable ecdsa) \
			$(use_enable gost) \
			$(use_enable ssl sha2) \
			$(use_with ssl)
	fi
}

src_compile() {
	emake -C drill
	if use examples; then
		emake -C examples
	fi
}

src_install() {
	cd "${S}"/drill
	emake DESTDIR="${D}" install
	dodoc ChangeLog.22-nov-2005 README REGRESSIONS

	if use examples; then
		cd "${S}"/examples
		emake DESTDIR="${D}" install
		newdoc README README.examples
	fi
}
