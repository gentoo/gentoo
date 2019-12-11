# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic readme.gentoo-r1

PPP_P="ppp-2.4.7"

DESCRIPTION="A user-mode PPPoE client and server suite for Linux"
HOMEPAGE="https://www.roaringpenguin.com/products/pppoe"
SRC_URI="https://dianne.skoll.ca/projects/rp-pppoe/download/${P}.tar.gz
	https://www.samba.org/ftp/pub/ppp/${PPP_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="tk"

RDEPEND="
	net-dialup/ppp:=
	tk? ( dev-lang/tk:= )
"
DEPEND=">=sys-kernel/linux-headers-2.6.25
	${RDEPEND}"

DOC_CONTENTS="Use pppoe-setup to configure your dialup connection"

pkg_setup() {
	# This is needed in multiple phases
	PPPD_VER=$(best_version net-dialup/ppp)
	PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER%%-*} #reduce it to ${PV}
}

PATCHES=(
	# Patch to enable integration of pppoe-start and pppoe-stop with
	# baselayout-1.11.x so that the pidfile can be found reliably per interface
	"${FILESDIR}/${PN}-3.10-gentoo-netscripts.patch"

	"${FILESDIR}/${PN}-3.10-username-charset.patch" # bug 82410
	"${FILESDIR}/${PN}-3.10-plugin-options.patch"
	"${FILESDIR}/${PN}-3.13-autotools.patch"
	"${FILESDIR}/${PN}-3.10-posix-source-sigaction.patch"
	"${FILESDIR}/${PN}-3.11-gentoo.patch"
	"${FILESDIR}/${PN}-3.11-kmode.patch" #364941
	"${FILESDIR}/${PN}-3.13-linux-headers.patch"
	"${FILESDIR}/${PN}-3.12-ifconfig-path.patch" #602344
)

src_prepare() {
	if has_version '<sys-kernel/linux-headers-2.6.35' ; then
		PATCHES+=(
			"${FILESDIR}/${PN}-3.10-linux-headers.patch" #334197
		)
	fi

	default

	cd "${S}"/src || die
	eautoreconf
}

src_configure() {
	addpredict /dev/ppp

	cd "${S}/src" || die
	# PPPD_VER variable is required for correct pppd detection
	# This was added through the rp-pppoe-*-autotools.patch
	econf PPPD_VER="${PPPD_VER}" --enable-plugin=../../ppp-${PPPD_VER}
}

src_compile() {
	cd "${S}/src" || die
	emake

	if use tk; then
		emake -C "${S}/gui"
	fi
}

src_install () {
	cd "${S}/src" || die
	emake DESTDIR="${D}" install #docdir=/usr/share/doc/${PF} install

	#Don't use compiled rp-pppoe plugin - see pkg_preinst below
	local pppoe_plugin="${ED%/}/etc/ppp/plugins/rp-pppoe.so"
	if [ -f "${pppoe_plugin}" ] ; then
		rm "${pppoe_plugin}" || die
	fi

	if use tk; then
		emake -C "${S}/gui" \
			DESTDIR="${D}" \
			datadir=/usr/share/doc/${PF}/ \
			install
		dosym doc/${PF}/tkpppoe /usr/share/tkpppoe
	fi

	newinitd "${FILESDIR}"/pppoe-server.initd pppoe-server
	newconfd "${FILESDIR}"/pppoe-server.confd pppoe-server

	readme.gentoo_create_doc
}

pkg_preinst() {
	# Use the rp-pppoe plugin that comes with net-dialup/pppd
	if [ -n "${PPPD_VER}" ] && [ -f "${EROOT%/}/usr/lib/pppd/${PPPD_VER}/rp-pppoe.so" ] ; then
		dosym ../../../usr/lib/pppd/${PPPD_VER}/rp-pppoe.so /etc/ppp/plugins/rp-pppoe.so
	fi
}
