# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools readme.gentoo-r1 toolchain-funcs

PPP_P="ppp-2.4.9"
PATCHES="${PN}-3.14-patches-01"

DESCRIPTION="A user-mode PPPoE client and server suite for Linux"
HOMEPAGE="https://dianne.skoll.ca/projects/rp-pppoe/"
SRC_URI="https://dianne.skoll.ca/projects/rp-pppoe/download/${P}.tar.gz
	https://github.com/paulusmack/ppp/archive/${PPP_P}.tar.gz
	https://dev.gentoo.org/~polynomial-c/dist/${PATCHES}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="tk"

RDEPEND="
	net-dialup/ppp:=
	sys-apps/iproute2
	tk? ( dev-lang/tk:= )
"
DEPEND=">=sys-kernel/linux-headers-2.6.25
	elibc_musl? ( net-libs/ppp-defs )
	${RDEPEND}"

DOC_CONTENTS="Use pppoe-setup to configure your dialup connection"

pkg_setup() {
	# This is needed in multiple phases
	PPPD_VER="$(best_version net-dialup/ppp)"
	PPPD_VER="${PPPD_VER#*/*-}" #reduce it to ${PV}-${PR}
	PPPD_VER="${PPPD_VER%%-*}" #reduce it to ${PV}
}

src_prepare() {
	if ! use elibc_musl ; then
		rm "${WORKDIR}/patches/${PN}-3.14-musl.patch" || die
	fi

	rm "${WORKDIR}/patches/${PN}-3.14-ifconfig-path.patch" || die

	eapply "${WORKDIR}/patches"
	eapply_user

	cd "${S}"/src || die
	eautoreconf
}

src_configure() {
	addpredict /dev/ppp

	cd src || die
	# Not a mistake! This comes from the GitHub tarball doing funky naming
	econf --enable-plugin=../../ppp-ppp-${PPPD_VER}
}

src_compile() {
	cd src || die
	emake AR="$(tc-getAR)"

	if use tk ; then
		emake -C "${S}/gui"
	fi
}

src_install() {
	cd src || die
	emake DESTDIR="${D}" install

	#Don't use compiled rp-pppoe plugin - see pkg_preinst below
	local pppoe_plugin="${ED}/etc/ppp/plugins/rp-pppoe.so"
	if [[ -f "${pppoe_plugin}" ]] ; then
		rm "${pppoe_plugin}" || die
	fi

	if use tk ; then
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
	if [[ -n "${PPPD_VER}" ]] && [[ -f "${EROOT}/usr/$(get_libdir)/pppd/${PPPD_VER}/rp-pppoe.so" ]] ; then
		dosym ../../../usr/$(get_libdir)/pppd/${PPPD_VER}/rp-pppoe.so /etc/ppp/plugins/rp-pppoe.so
	fi
}
