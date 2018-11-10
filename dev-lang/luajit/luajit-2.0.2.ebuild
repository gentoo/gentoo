# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib pax-utils versionator toolchain-funcs

MY_PV="$(get_version_component_range 1-3)"
MY_P="LuaJIT-${MY_PV}"
if [[ $(get_version_component_range 4) != "" ]]; then
	HOTFIX="v${PV}"
	HOTFIX="${HOTFIX/_p/_hotfix}.patch"
fi

DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="http://luajit.org/"
SRC_URI="http://luajit.org/download/${MY_P}.tar.gz
	${HOTFIX:+http://luajit.org/download/${HOTFIX}}"

LICENSE="MIT"
# this should probably be pkgmoved to 2.0 for sake of consistency.
SLOT="2"
KEYWORDS="amd64 arm ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="lua52compat"

S="${WORKDIR}/${MY_P}"

src_prepare(){
	if [[ -n ${HOTFIX} ]]; then
		epatch "${DISTDIR}/${HOTFIX}"
	fi
	sed -i "s,PREFIX= /usr/local,PREFIX= ${EPREFIX}/usr," Makefile || die 'sed failed.'
	sed -i "s,/lib,/$(get_libdir)," etc/${PN}.pc || die 'sed2 failed.'
}

src_compile() {
	emake \
		Q= \
		PREFIX="${EPREFIX}/usr" \
		DESTDIR="${D}" \
		HOST_CC="$(tc-getBUILD_CC)" \
		STATIC_CC="$(tc-getCC)" \
		DYNAMIC_CC="$(tc-getCC) -fPIC" \
		TARGET_LD="$(tc-getCC)" \
		TARGET_AR="$(tc-getAR) rcus" \
		TARGET_STRIP="true" \
		INSTALL_LIB="${ED%/}/usr/$(get_libdir)" \
		XCFLAGS="$(usex lua52compat "-DLUAJIT_ENABLE_LUA52COMPAT" "")"
}

src_install(){
	emake install \
		DESTDIR="${D}" \
		HOST_CC="$(tc-getBUILD_CC)" \
		STATIC_CC="$(tc-getCC)" \
		DYNAMIC_CC="$(tc-getCC) -fPIC" \
		TARGET_LD="$(tc-getCC)" \
		TARGET_AR="$(tc-getAR) rcus" \
		TARGET_STRIP="true" \
		INSTALL_LIB="${ED%/}/usr/$(get_libdir)"

	pax-mark m "${ED}usr/bin/luajit-${MY_PV}"

	cd "${S}"/doc
	dohtml -r *
}
