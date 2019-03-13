# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs eutils

DESCRIPTION="simple Mode S decoder for RTLSDR devices"
#Original repo
#HOMEPAGE="https://github.com/antirez/dump1090"
#Repo that has actually been touched recenly
HOMEPAGE="https://github.com/mutability/dump1090"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mutability/${PN}.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	COMMIT="fb5942dba6505a21cbafc7905a5a7c513b214dc9"
	SRC_URI="https://github.com/mutability/dump1090/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="net-wireless/rtl-sdr
		virtual/libusb:1"
DEPEND="${RDEPEND}"

src_compile() {
	emake CC="$(tc-getCC)" \
		UNAME="Linux" \
		DUMP1090_VERSION=${PV} \
		CFLAGS="$($(tc-getPKG_CONFIG) --cflags librtlsdr) ${CFLAGS}" \
		EXTRACFLAGS="-DHTMLPATH=\\\"/usr/share/dump1090/html\\\"" \
		LIBS="${LDFLAGS} $($(tc-getPKG_CONFIG) --libs librtlsdr) -lm -lpthread"
}

src_install() {
	dobin ${PN}
	dobin view1090
	dodoc README.md

	insinto /usr/share/${PN}/html
	doins -r public_html/*

	insinto /usr/share/${PN}/tools
	doins -r tools/*

	newdoc debian/lighttpd/89-dump1090.conf lighttpd.conf
	newdoc debian/nginx/dump1090-mutability nginx.conf
}
