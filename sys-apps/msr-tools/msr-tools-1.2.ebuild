# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/msr-tools/msr-tools-1.2.ebuild,v 1.2 2013/08/24 16:00:56 maekke Exp $

EAPI=5
CONFIG_CHECK="~X86_MSR"
DEB_P="msr-tools_1.2-3"

inherit eutils linux-info toolchain-funcs

DESCRIPTION="Utilities allowing the read and write of CPU model-specific registers (MSR)"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/cpu/msr-tools/"
SRC_URI="http://dev.gentoo.org/~kensington/distfiles/${P}.tar.gz mirror://debian/pool/main/m/${PN}/${DEB_P}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	epatch "${WORKDIR}"/${DEB_P}.diff
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dosbin rdmsr
	dosbin wrmsr

	doman ${P}/debian/rdmsr.1 ${P}/debian/wrmsr.1
}
