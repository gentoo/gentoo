# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool linux-info systemd

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git"
else
	SRC_URI="https://www.kernel.org/pub/linux/utils/kernel/kexec/${P/_/-}.tar.xz"
	[[ "${PV}" == *_rc* ]] || \
	KEYWORDS="amd64 arm64 ~ppc64 x86"
fi

DESCRIPTION="Load another kernel from the currently executing Linux kernel"
HOMEPAGE="https://kernel.org/pub/linux/utils/kernel/kexec/"

S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-2"
SLOT="0"
IUSE="booke lzma selinux xen zlib zstd"

REQUIRED_USE="lzma? ( zlib )"

DEPEND="
	lzma? ( app-arch/xz-utils )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-kdump )
"

CONFIG_CHECK="~KEXEC"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.4-disable-kexec-test.patch
	"${FILESDIR}"/${PN}-2.0.4-out-of-source.patch
)

src_prepare() {
	default

	if [[ "${PV}" == 9999 ]] ; then
		eautoreconf
	else
		elibtoolize
	fi
}

src_configure() {
	# GNU Make's $(COMPILE.S) passes ASFLAGS to $(CCAS), CCAS=$(CC)
	export ASFLAGS="${CCASFLAGS}"

	local myeconfargs=(
		$(use_with booke)
		$(use_with lzma)
		$(use_with xen)
		$(use_with zlib)
		$(use_with zstd)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc "${FILESDIR}"/README.Gentoo

	newinitd "${FILESDIR}"/kexec-r2.init kexec

	insinto /etc
	doins "${FILESDIR}"/kexec.conf
	dosym ../kexec.conf /etc/conf.d/kexec

	dosbin "${FILESDIR}"/kexec-auto-load
	systemd_newunit "${FILESDIR}"/kexec.service-r1 kexec.service
}

pkg_postinst() {
	local n_root_args=$(grep -o -- '\<root=' /proc/cmdline 2>/dev/null | wc -l)
	local has_rootpart_set=no
	if [[ -f "${EROOT}/etc/conf.d/kexec" ]]; then
		if grep -q -E -- '^ROOTPART=' "${EROOT}/etc/conf.d/kexec" 2>/dev/null; then
			has_rootpart_set=yes
		fi
	fi

	if [[ ${n_root_args} -gt 1 && "${has_rootpart_set}" == "no"  ]]; then
		ewarn "WARNING: Multiple root arguments (root=) on kernel command-line detected!"
		ewarn "This was probably caused by a previous version of ${PN}."
		ewarn "Please reboot system once *without* kexec to avoid boot problems"
		ewarn "in case running system and initramfs do not agree on detected"
		ewarn "root device name!"
	fi
}
