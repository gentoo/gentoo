# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit linux-info linux-mod flag-o-matic

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dynup/${PN}.git"
else
	SRC_URI="https://github.com/dynup/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Dynamic kernel patching for Linux"
HOMEPAGE="https://github.com/dynup/kpatch"

LICENSE="GPL-2+"
SLOT="0"
IUSE="examples +modules test"

RDEPEND="
	app-crypt/pesign
	dev-libs/openssl:0=
	sys-libs/zlib
	sys-apps/pciutils
"

DEPEND="
	${RDEPEND}
	test? ( dev-util/shellcheck )
	dev-libs/elfutils
	sys-devel/bison
"

pkg_pretend() {
	if kernel_is gt 3 9 0; then
		if ! linux_config_exists; then
			eerror "Unable to check the currently running kernel for kpatch support"
			eerror "Please be sure a .config file is available in the kernel src dir"
			eerror "and ensure the kernel has been built."
		else
			# Fail to build if these kernel options are not enabled (see kpatch/kmod/core/Makefile)
			CONFIG_CHECK="FUNCTION_TRACER HAVE_FENTRY MODULES SYSFS KALLSYMS_ALL"
			ERROR_FUNCTION_TRACER="CONFIG_FUNCTION_TRACER must be enabled in the kernel's config file"
			ERROR_HAVE_FENTRY="CONFIG_HAVE_FENTRY must be enabled in the kernel's config file"
			ERROR_MODULES="CONFIG_MODULES must be enabled in the kernel's config file"
			ERROR_SYSFS="CONFIG_SYSFS must be enabled in the kernel's config file"
			ERROR_KALLSYMS_ALL="CONFIG_KALLSYMS_ALL must be enabled in the kernel's config file"
		fi
	else
		eerror
		eerror "kpatch is not available for Linux kernels below 4.0.0"
		eerror
		die "Upgrade the kernel sources before installing kpatch."
	fi

	check_extra_config
}

src_prepare() {
	replace-flags '-O?' '-O1'
	default
}

src_compile() {
	set_arch_to_kernel
	emake all
}

src_install() {
	set_arch_to_kernel
	emake DESTDIR="${D}" PREFIX="/usr" install

	einstalldocs
}
