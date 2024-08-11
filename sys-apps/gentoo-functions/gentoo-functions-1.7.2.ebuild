# Copyright 2014-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Base functions required by all Gentoo systems"
HOMEPAGE="https://gitweb.gentoo.org/proj/gentoo-functions.git"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gentoo-functions.git"
else
	SRC_URI="https://gitweb.gentoo.org/proj/gentoo-functions.git/snapshot/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local emesonargs=(
		# Deliberately avoid /usr as consumers assume we're at /lib/gentoo.
		--prefix="${EPREFIX:-/}"
		--mandir="${EPREFIX}/usr/share/man"
		$(meson_use test tests)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	if [[ ${EPREFIX} ]]; then
		while read -r; do
			if [[ ${REPLY} == $'\t'genfun_prefix= ]]; then
				printf '\tgenfun_prefix=%q\n' "${EPREFIX}"
			else
				printf '%s\n' "${REPLY}"
			fi || ! break
		done < "${ED}/lib/gentoo/functions.sh" > "${T}/functions.sh" \
		&& mv -- "${T}/functions.sh" "${ED}/lib/gentoo/functions.sh" \
		|| die
	fi
}
