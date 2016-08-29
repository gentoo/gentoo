# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CONFIG_CHECK="~X86_MSR"
inherit eutils linux-info toolchain-funcs

DESCRIPTION="Utilities allowing the read and write of CPU model-specific registers (MSR)"
HOMEPAGE="https://01.org/msr-tools"
SRC_URI="https://01.org/sites/default/files/downloads/${PN}/${P}.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}/${PN}-master

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dosbin rdmsr
	dosbin wrmsr
}
