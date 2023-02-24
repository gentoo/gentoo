# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PowerShell - binary precompiled for glibc"
HOMEPAGE="https://microsoft.com/powershell"
BASE_URI="https://github.com/PowerShell/PowerShell/releases/download"
SRC_URI="
	amd64? ( ${BASE_URI}/v${PV}/powershell-${PV}-linux-x64.tar.gz )
	arm?   ( ${BASE_URI}/v${PV}/powershell-${PV}-linux-arm32.tar.gz )
	arm64? ( ${BASE_URI}/v${PV}/powershell-${PV}-linux-arm64.tar.gz )
"
S=${WORKDIR}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+pwsh-symlink"
REQUIRED_USE="elibc_glibc"

RDEPEND="
	app-crypt/mit-krb5:0/0
	dev-util/lttng-ust:0/2.12
	sys-libs/pam:0/0
	sys-libs/zlib:0/1
	|| (
		dev-libs/openssl-compat:1.0.0
		=dev-libs/openssl-1.0*:0/0
	)
	pwsh-symlink? ( !app-shells/pwsh )
"

QA_PREBUILT="*"

src_install() {
	local dest=opt/pwsh
	dodir ${dest}

	local broken_symlinks=( libcrypto.so.1.0.0 libssl.so.1.0.0 )
	local symlink
	for symlink in "${broken_symlinks[@]}" ; do
		[[ -L ${symlink} ]] && { rm "${symlink}" || die ; }
	done

	mv "${S}/"* "${ED}"/${dest}/ || die
	fperms 0755 /${dest}/pwsh

	dosym ../../${dest}/pwsh /usr/bin/pwsh-bin
	use pwsh-symlink && dosym ../../${dest}/pwsh /usr/bin/pwsh
}
