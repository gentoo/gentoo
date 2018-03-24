# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs versionator

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Intel processor microcode update utility"
HOMEPAGE="https://pagure.io/microcode_ctl"
SRC_URI="https://releases.pagure.org/${PN/-/_}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="selinux"

DEPEND=""
RDEPEND=">=sys-firmware/intel-microcode-20090330[monolithic(+)]
	selinux? ( sec-policy/selinux-cpucontrol )"

S=${WORKDIR}/${MY_P}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${CPPFLAGS} ${LDFLAGS}"
}

src_install() {
	dosbin microcode_ctl
	doman microcode_ctl.8
	dodoc Changelog README
}

pkg_preinst() {
	local _v
	for _v in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 1.28-r1 ${_v}; then
			# This is an upgrade
			elog "The init scripts have been removed as they are unsafe.  If you want to update"
			elog "the microcode in your system, please use an initramfs.  See bug #528712#41 for"
			elog "details (and bug #557278 for genkernel users)."
		fi

		# Show this elog only once
		break
	done
}
