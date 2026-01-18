# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit wrapper

DESCRIPTION="Cross-platform automation and configuration tool (binary package)"
HOMEPAGE="https://microsoft.com/powershell/
	https://github.com/PowerShell/PowerShell/"

BASE_URI="https://github.com/PowerShell/PowerShell/releases/download/"
SRC_URI="
	amd64? ( ${BASE_URI}/v${PV}/powershell-${PV}-linux-x64.tar.gz )
	arm64? ( ${BASE_URI}/v${PV}/powershell-${PV}-linux-arm64.tar.gz )
	arm?   ( ${BASE_URI}/v${PV}/powershell-${PV}-linux-arm32.tar.gz )
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="amd64 arm arm64"
REQUIRED_USE="elibc_glibc"
RESTRICT="splitdebug"

RDEPEND="
	app-crypt/mit-krb5:0/0
	dev-libs/icu
	|| (
		dev-util/lttng-ust-compat:0/2.12
		dev-util/lttng-ust:0/2.12
	)
	sys-libs/pam:0/0
	virtual/zlib:0/1
	|| (
		dev-libs/openssl-compat:1.0.0
		=dev-libs/openssl-1.0*:0/0
	)
"
IDEPEND="
	app-eselect/eselect-pwsh
"

QA_PREBUILT="*"

src_install() {
	local -a broken_symlinks
	broken_symlinks=( libcrypto.so.1.0.0 libssl.so.1.0.0 )

	local symlink
	for symlink in "${broken_symlinks[@]}" ; do
		if [[ -L "${symlink}" ]] ; then
			rm "${symlink}" || die "failed to remove ${symlink}"
		fi
	done

	local dest="opt/${PN}-${SLOT}"
	local dest_root="/${dest}"

	insinto "${dest_root}"
	doins -r .

	fperms 0755 "${dest_root}/pwsh"

	local gentoo_path='PSModulePath="${PSModulePath}:${EPREFIX}/usr/share/GentooPowerShell/Modules:"'
	make_wrapper "${PN}-${SLOT}" "env ${gentoo_path} ${dest_root}/pwsh"
}

pkg_postinst() {
	eselect pwsh update ifunset
}

pkg_postrm() {
	eselect pwsh update ifunset
}
