# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git"
else
	SRC_URI="mirror://kernel/linux/utils/kernel/kexec/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

inherit libtool linux-info systemd

DESCRIPTION="Load another kernel from the currently executing Linux kernel"
HOMEPAGE="https://kernel.org/pub/linux/utils/kernel/kexec/"

LICENSE="GPL-2"
SLOT="0"
IUSE="booke lzma xen zlib"

REQUIRED_USE="lzma? ( zlib )"

DEPEND="
	lzma? ( app-arch/xz-utils )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~KEXEC"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.4-disable-kexec-test.patch
	"${FILESDIR}"/${PN}-2.0.4-out-of-source.patch
)

pkg_setup() {
	# GNU Make's $(COMPILE.S) passes ASFLAGS to $(CCAS), CCAS=$(CC)
	export ASFLAGS="${CCASFLAGS}"
}

src_prepare() {
	default
	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	else
		elibtoolize
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_with booke)
		$(use_with lzma)
		$(use_with xen)
		$(use_with zlib)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc "${FILESDIR}"/README.Gentoo

	newinitd "${FILESDIR}"/kexec.init-2.0.13-r1 kexec
	newconfd "${FILESDIR}"/kexec.conf-2.0.4 kexec

	insinto /etc
	doins "${FILESDIR}"/kexec.conf

	insinto /etc/kernel/postinst.d
	doins "${FILESDIR}"/90_kexec

	systemd_dounit "${FILESDIR}"/kexec.service
}

pkg_postinst() {
	if systemd_is_booted || has_version sys-apps/systemd; then
		elog "For systemd support the new config file is"
		elog "   /etc/kexec.conf"
		elog "Please adopt it to your needs as there is no autoconfig anymore"
	fi
}
