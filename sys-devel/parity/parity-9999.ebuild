# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git@github.com:haubi/parity.git https://github.com/haubi/parity.git"
	DEPEND="dev-util/confix"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS=""
fi
DESCRIPTION="A POSIX to native Win32 Cross-Compiler Tool (requires Visual Studio)"
HOMEPAGE="https://github.com/haubi/parity"

LICENSE="LGPL-3"
SLOT="0"
IUSE=""

if [[ ${PV} == 9999 ]]; then
	src_prepare() {
		confix --bootstrap || die
		default
	}
fi

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# create i586-pc-winnt-g[++|cc|..] links..
	local exeext=

	[[ -f ${ED}usr/bin/parity.gnu.gcc.exe ]] && exeext=.exe

	# create cross compiler syms, also for former versioned winnt profiles
	local v t
	for v in "" 5.2 6.1; do
		dosym /usr/bin/parity.gnu.gcc${exeext} /usr/bin/i586-pc-winnt${v}-c++
		dosym /usr/bin/parity.gnu.gcc${exeext} /usr/bin/i586-pc-winnt${v}-g++
		for t in gcc ld windres ar nm ranlib strip; do
			if [[ -e "${ED}"usr/bin/parity.gnu.${t}${exeext} ]]; then
				dosym /usr/bin/parity.gnu.${t}${exeext} /usr/bin/i586-pc-winnt${v}-${t}
			else
				dosym /usr/bin/parity.gnu.${t} /usr/bin/i586-pc-winnt${v}-${t}
			fi
		done
	done

	# we don't need the header files installed by parity... private
	# header files are supported with a patch from 2.1.0-r1 onwards,
	# so they won't be there anymore, but -f does the job in any case.
	rm -f "${ED}"/usr/include/*.h
}
