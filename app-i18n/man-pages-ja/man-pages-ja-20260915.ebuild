# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Collection of manual pages translated into Japanese"
HOMEPAGE="https://linuxjm.sourceforge.io/"
SRC_URI="https://github.com/linux-jm/manual/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2+ GPL-2 GPL-3+ LGPL-2 LGPL-2+ 0BSD BSD BSD-2 MIT ISC HPND FDL-1.1+ LDP-1 LDP-1a man-pages Texinfo-manual"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="virtual/man"

src_prepare() {
	local -A pkgs
	# remove man pages that are provided by other packages.
	# - sys-apps/man-db +nls
	pkgs["man"]=
	# - sys-apps/shadow +nls
	pkgs["shadow"]=
	pkgs["GNU_coreutils"]="groups"
	pkgs["LDP_man-pages"]="passwd"
	pkgs["util-linux"]="chfn chsh newgrp vigr vipw"
	# - app-arch/rpm +nls
	pkgs["rpm"]=

	local pkg regex
	for pkg in "${!pkgs[@]}"; do
		if [[ -z ${pkgs[${pkg}]} ]]; then
			regex+="${pkg}\\|"
		else
			sed -i "/:\(${pkgs[${pkg}]// /\\|}\):/d" manual/${pkg}/translation_list || die
		fi
	done
	sed -i "/^\(${regex%\\|}\)/s/Y$/N/" script/pkgs.list || die
	default
}

src_compile() {
	:
}

src_install() {
	local pkg ans tl man
	local _ name sec
	while read -r pkg ans; do
		tl="manual/${pkg}/translation_list"
		[[ ${ans} == "N" || ! -f ${tl} ]] && continue

		einfo "install ${pkg}"
		man=()
		while IFS=: read -r _ _ _ _ name sec _; do
			man+=( "manual/${pkg}/man${sec}/${name}.${sec}" )
		done < <(sed "/^\(\xc3\x97\|\xe2\x96\xb2\|\xe2\x96\xb3\|\xe2\x97\x8f\|\xe2\x80\xbb\|$\)/d" ${tl})
		doman -i18n=ja "${man[@]}"
	done < <(tac script/pkgs.list | grep -v "^#")
	einstalldocs
}
