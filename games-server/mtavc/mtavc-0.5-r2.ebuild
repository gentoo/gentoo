# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="dedicated server for GTA3 multiplayer"
HOMEPAGE="http://mtavc.com/"
SRC_URI="http://files.gonnaplay.com/201/MTAServer$(ver_rs 0-1 '_')-linux.tar.gz"
S="${WORKDIR}"

LICENSE="MTA-0.5"
SLOT="0"
KEYWORDS="-* ~x86"
RESTRICT="bindist mirror"

RDEPEND="sys-libs/glibc
	sys-libs/libstdc++-v3:5"

QA_PREBUILT="/opt/${PN}/MTAServer"
QA_EXECSTACK="/opt/${PN}/MTAServer"

src_prepare() {
	default

	sed -i 's:NoName:Gentoo:' mtaserver.conf || die
}

src_install() {
	local dir=/opt/${PN}
	local files="banned.lst motd.txt mtaserver.conf"
	local f

	dobin "${FILESDIR}"/mtavc
	sed -i -e "s:GENTOO_DIR:${dir}:" "${D}/usr/bin"/mtavc

	exeinto "${dir}"
	newexe MTAServer${PV} MTAServer
	insinto /etc/${PN}
	doins ${files}
	dodoc README CHANGELOG
	for f in ${files} ; do
		dosym ../../etc/${PN}/${f} "${dir}"/${f}
	done
}
