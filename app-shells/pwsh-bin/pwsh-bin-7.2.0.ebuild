# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="PowerShell - binary precompiled for glibc"
HOMEPAGE="https://powershell.org/"
LICENSE="MIT"
QA_PREBUILT="*"
SRC_URI="
	amd64? ( https://github.com/PowerShell/PowerShell/releases/download/v${PV}/powershell-${PV}-linux-x64.tar.gz )
	arm?   ( https://github.com/PowerShell/PowerShell/releases/download/v${PV}/powershell-${PV}-linux-arm32.tar.gz )
	arm64? ( https://github.com/PowerShell/PowerShell/releases/download/v${PV}/powershell-${PV}-linux-arm64.tar.gz )
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
RDEPEND="
	app-crypt/mit-krb5:0/0
	dev-util/lttng-ust:0
	|| ( dev-libs/openssl-compat:1.0.0 =dev-libs/openssl-1.0*:0/0 )
	sys-libs/pam:0/0
	sys-libs/zlib:0/1
	pwsh-symlink? ( !app-shells/pwsh )
"
IUSE="+pwsh-symlink"
REQUIRED_USE="elibc_glibc"

S=${WORKDIR}

src_install() {
	local dest=opt/pwsh broken_symlinks=(libcrypto.so.1.0.0 libssl.so.1.0.0) symlink
	dodir "${dest}"

	for symlink in "${broken_symlinks[@]}"; do
		[[ -L ${symlink} ]] && { rm "${symlink}" || die; }
	done

	mv "${S}/"* "${ED}/${dest}/" || die
	fperms 0755 "/${dest}/pwsh"

	dosym "../../${dest}/pwsh" "/usr/bin/pwsh-bin"
	use pwsh-symlink && dosym "../../${dest}/pwsh" "/usr/bin/pwsh"
}
