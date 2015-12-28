# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit flag-o-matic toolchain-funcs eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://net-tools.git.sourceforge.net/gitroot/net-tools/net-tools"
	inherit git-2
else
	PATCH_VER="1"
	SRC_URI="mirror://gentoo/${P}.tar.xz
		mirror://gentoo/${P}-patches-${PATCH_VER}.tar.xz"
	KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Standard Linux networking tools"
HOMEPAGE="http://net-tools.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls old-output selinux static"

RDEPEND="!<sys-apps/openrc-0.9.9.3
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	selinux? ( virtual/pkgconfig )
	app-arch/xz-utils"

maint_pkg_create() {
	cd /usr/local/src/net-tools
	#git-update
	local stamp=$(date --date="$(git log -n1 --pretty=format:%ci master)" -u +%Y%m%d%H%M%S)
	local pv="${PV/_p*}_p${stamp}"; pv=${pv/9999/1.60}
	local p="${PN}-${pv}"
	git archive --prefix="${p}/" master | tar xf - -C "${T}"
	pushd "${T}" >/dev/null
	sed -i "/^RELEASE/s:=.*:=${pv}:" */Makefile || die
	tar cf - ${p}/ | xz > ${p}.tar.xz
	popd >/dev/null

	local patches="${p}-patches-${PATCH_VER:-1}"
	local d="${T}/${patches}"
	mkdir "${d}"
	git format-patch -o "${d}" master..gentoo > /dev/null
	echo "From https://cgit.gentoo.org/proj/net-tools.git" > "${d}"/README
	tar cf - -C "${T}" ${d##*/} | xz > "${T}"/${patches}.tar.xz
	rm -rf "${d}"

	du -b "${T}"/*.tar.xz
}

pkg_setup() { [[ -n ${VAPIER_LOVES_YOU} ]] && maint_pkg_create ; }

set_opt() {
	local opt=$1 ans
	shift
	ans=$("$@" && echo y || echo n)
	einfo "Setting option ${opt} to ${ans}"
	sed -i \
		-e "/^bool.* ${opt} /s:[yn]$:${ans}:" \
		config.in || die
}

src_prepare() {
	if [[ -n ${PATCH_VER} ]] ; then
		use old-output || EPATCH_EXCLUDE="0001-revert-621a2f376334f8097604b9fee5783e0f1141e66d-for-.patch"
		EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch "${WORKDIR}"/${P}-patches-${PATCH_VER}
	fi
}

src_configure() {
	set_opt I18N use nls
	set_opt HAVE_HWIB has_version '>=sys-kernel/linux-headers-2.6'
	set_opt HAVE_HWTR has_version '<sys-kernel/linux-headers-3.5'
	set_opt HAVE_HWSTRIP has_version '<sys-kernel/linux-headers-3.6'
	set_opt HAVE_SELINUX use selinux
	if use static ; then
		append-flags -static
		append-ldflags -static
	fi
	tc-export AR CC
	yes "" | ./configure.sh config.in || die
}

src_install() {
	emake DESTDIR="${ED}" install || die
	dodoc README README.ipv6 TODO
}

pkg_postinst() {
	einfo "etherwake and such have been split into net-misc/ethercard-diag"
}
