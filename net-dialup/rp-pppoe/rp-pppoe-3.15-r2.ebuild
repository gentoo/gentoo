# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools readme.gentoo-r1 toolchain-funcs

PATCHSET="${PN}-3.14-patches-01"
PATCHES=(
	"${FILESDIR}/rp-pppoe-3.15-no_max_interfaces.patch"
)

DESCRIPTION="A user-mode PPPoE client and server suite for Linux"
HOMEPAGE="https://dianne.skoll.ca/projects/rp-pppoe/"
SRC_URI="https://dianne.skoll.ca/projects/rp-pppoe/download/${P}.tar.gz
	https://dev.gentoo.org/~polynomial-c/dist/${PATCHSET}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
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

	PPPD_PLUGIN_DIR="/usr/$(get_libdir)/pppd/${PPPD_VER}"
}

src_prepare() {
	if ! use elibc_musl ; then
		rm "${WORKDIR}/patches/${PN}-3.14-musl.patch" || die
	fi

	rm "${WORKDIR}/patches/${PN}-3.14-ifconfig-path.patch" || die

	eapply "${WORKDIR}/patches"
	eapply "${PATCHES[@]}"
	eapply_user

	cd "${S}"/src || die
	eautoreconf
}

src_configure() {
	addpredict /dev/ppp

	cd src || die

	econf --enable-plugin=/usr/include/pppd
}

src_compile() {
	cd src || die
	emake AR="$(tc-getAR)" PLUGIN_PATH=rp-pppoe.so PLUGIN_DIR="${PPPD_PLUGIN_DIR}"

	if use tk ; then
		emake -C "${S}/gui"
	fi
}

src_install() {
	cd src || die
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}" PLUGIN_DIR="${PPPD_PLUGIN_DIR}" install

	# We don't need this README file here.
	rm "${ED}${PPPD_PLUGIN_DIR}/README" || die "Error removing ${PPPD_PLUGIN_DIR}/README from installation"

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
