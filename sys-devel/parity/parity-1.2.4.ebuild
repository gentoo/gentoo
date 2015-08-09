# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="An Interix to native Win32 Cross-Compiler Tool (requires Visual Studio)"
HOMEPAGE="http://www.sourceforge.net/projects/parity/"

if [[ ${PV} == 9999 ]]; then
	inherit subversion
	ESVN_REPO_URI="https://parity.svn.sf.net/svnroot/parity/trunk"
	ESVN_BOOTSTRAP="confix --bootstrap"
	ESVN_PROJECT="${PN}"
	KEYWORDS=""

	DEPEND="dev-util/confix"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~x86-interix ~x86-winnt"
fi

LICENSE="LGPL-3"
SLOT="0"
IUSE=""

pkg_setup() {
	if [ -z "${MSSDK}" ]; then
		einfo "NOTE: When using Visual Studio 2008, the Platform SDK is no longer"
		einfo "installed alongside with the other components, but has it's own"
		einfo "root directory, most likely something like this:"
		einfo ""
		einfo "  C:\\Program Files\\Microsoft SDKs\\Windows\\v6.0A"
		einfo ""
		einfo "To make parity find it's paths correctly, please set MSSDK to the"
		einfo "value correspoding to the above example for your system."
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# create i586-pc-winnt*-g[++|cc|..] links..
	local exeext=

	[[ -f ${ED}/usr/bin/parity.gnu.gcc.exe ]] && exeext=.exe

	# create cross compiler syms
	dosym /usr/bin/parity.gnu.gcc${exeext} /usr/bin/i586-pc-winnt$(uname -r)-gcc
	dosym /usr/bin/parity.gnu.gcc${exeext} /usr/bin/i586-pc-winnt$(uname -r)-c++
	dosym /usr/bin/parity.gnu.gcc${exeext} /usr/bin/i586-pc-winnt$(uname -r)-g++
	dosym /usr/bin/parity.gnu.ld${exeext} /usr/bin/i586-pc-winnt$(uname -r)-ld

	# we don't need the header files installed by parity... private
	# header files are supported with a patch from 2.1.0-r1 onwards,
	# so they won't be there anymore, but -f does the job in any case.
	rm -f "${ED}"/usr/include/*.h
}
