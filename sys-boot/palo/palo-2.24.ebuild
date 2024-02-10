# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="PALO: PArisc Linux Loader"
HOMEPAGE="https://parisc.wiki.kernel.org/ https://git.kernel.org/pub/scm/linux/kernel/git/deller/palo.git/"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/deller/palo.git"
	inherit git-r3
else
	SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/deller/${PN}.git/snapshot/${P}.tar.gz"
	KEYWORDS="-* hppa"
fi

LICENSE="GPL-2"
SLOT="0"

PATCHES=(
	"${FILESDIR}"/${PN}-2.00-toolchain.patch
)

src_compile() {
	local target
	for target in '-C palo' '-C ipl' 'iplboot'; do
		emake AR="$(tc-getAR)" CC="$(tc-getCC)" LD="$(tc-getLD)" ${target}
	done
}

src_install() {
	into /
	dosbin palo/palo

	insinto /usr/share/palo
	doins iplboot

	insinto /etc
	doins "${FILESDIR}"/palo.conf

	insinto /etc/kernel/postinst.d
	insopts -m 0744
	doins "${FILESDIR}"/99palo

	doman palo.8

	dodoc TODO debian/changelog README.html
}
