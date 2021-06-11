# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Automated port scan detector and response tool"
# Seems like CISCO took the site down?
HOMEPAGE="https://sourceforge.net/projects/sentrytools/"
SRC_URI="mirror://sourceforge/sentrytools/${P}.tar.gz"
S="${WORKDIR}"/${PN}_beta

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86 ~x64-macos"
IUSE="kernel_Darwin kernel_linux kernel_FreeBSD kernel_SunOS"

RDEPEND="kernel_Darwin? ( app-shells/tcsh )"

PATCHES=(
	"${FILESDIR}"/${P}-conf.patch
	"${FILESDIR}"/${P}-config.h.patch
	"${FILESDIR}"/${P}-gcc.patch
	"${FILESDIR}"/${P}-ignore.csh.patch
)

src_compile() {
	local target

	if use kernel_Darwin ; then
		target="osx"
	elif use kernel_linux ; then
		target="linux"
	elif use kernel_FreeBSD ; then
		target="freebsd"
	elif use kernel_SunOS ; then
		target="solaris"
	fi

	if [[ -z "${target}" ]] ; then
		elog "Using 'generic' target for your platform"
		target="generic"
	else
		elog "Using '${target}' (detected) target for your platform"
	fi

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${CPPFLAGS} ${LDFLAGS}" "${target}"
}

src_install() {
	doman "${FILESDIR}"/{portsentry.8,portsentry.conf.5}

	dobin portsentry ignore.csh
	dodoc README* CHANGES CREDITS
	newdoc portsentry.ignore portsentry.ignore.sample
	newdoc portsentry.conf portsentry.conf.sample

	insinto /etc/portsentry
	newins portsentry.ignore portsentry.ignore.sample
	newins portsentry.conf portsentry.conf.sample

	newinitd "${FILESDIR}"/portsentry.rc6 portsentry
	newconfd "${FILESDIR}"/portsentry.confd portsentry
}
