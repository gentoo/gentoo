# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Shotgun assembly and alignment utilities"
HOMEPAGE="http://www.phrap.org/"
SRC_URI="phrap-${PV}-distrib.tar.gz"

LICENSE="phrap"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-lang/perl
	dev-perl/Tk"

S="${WORKDIR}"

RESTRICT="fetch"
PATCHES=( "${FILESDIR}/${PN}-1.080812-fix-build-system.patch" )

pkg_nofetch() {
	einfo "Please visit http://www.phrap.org/phredphrapconsed.html and obtain the file"
	einfo "\"distrib.tar.gz\", then rename it to \"phrap-${PV}-distrib.tar.gz\""
	einfo "and put it into your DISTDIR directory."
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin cross_match loco phrap phrapview swat
	newbin cluster cluster_phrap

	local i
	for i in {general,phrap,swat}.doc; do
		newdoc ${i} ${i}.txt
	done
}
