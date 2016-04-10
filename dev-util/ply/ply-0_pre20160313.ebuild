# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools linux-info

DESCRIPTION="Dynamic instrumentation of the Linux kernel with BPF and kprobes"
HOMEPAGE="https://github.com/iovisor/ply"
EGIT_COMMIT="cfc56c789ad1eff1080ecb0dad18d009b91ae8ea"
SRC_URI="https://github.com/iovisor/ply/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}-${EGIT_COMMIT}

pkg_pretend() {
	local CONFIG_CHECK="~BPF ~BPF_SYSCALL ~NET_CLS_BPF ~NET_ACT_BPF
		~BPF_JIT ~HAVE_BPF_JIT ~BPF_EVENTS"

	check_extra_config
}

src_prepare() {
	eapply_user
	eautoreconf
	default
}

src_configure() {
	local econf_args=() kerneldir_orig
	if [[ -d ${KERNEL_DIR} ]]; then
		# Using KBUILD_OUTPUT can fail, depending on the source tree
		# state (it might demand that we make mrproper). Therefore,
		# create a symlink copy of the source tree so that we are free
		# to clean things up as needed.
		kerneldir_orig=${KERNEL_DIR}
		cp -sR "${kerneldir_orig}" "${T}/kerneldir" || die
		export KERNEL_DIR="${T}/kerneldir"
		pushd "${KERNEL_DIR}" || die
		# avoid sandbox violation for scripts/kconfig/.conf.cmd
		find . -name '\.*' -delete
		cp "${kerneldir_orig}/.config" ./.config || die
		set_arch_to_kernel
		make mrproper oldconfig prepare || die
		popd || die
		econf_args+=(--with-kerneldir="${KERNEL_DIR}")
	fi
	econf "${econf_args[@]}"
}

src_install() {
	default
	rm -f "${ED}/usr/share/doc/${P}/COPYING"
}
