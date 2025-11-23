# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/kovidgoyal/rapydscript-ng"
	# this is nodejs software, so possibly unfixable. I am sorry.
	# Instead, we will have to generate this with the live ebuild and upload assets
	# using EGIT_OVERRIDE_COMMIT for the tagged version we need.
	BDEPEND="app-arch/libarchive"

	inherit git-r3
else
	SRC_URI="
		https://github.com/kovidgoyal/rapydscript-ng/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/rapydscript-ng-node_modules-${PV}.tar.xz
	"
	KEYWORDS="amd64 ~arm64"
fi

inherit edo

DESCRIPTION="Pythonic JavaScript that doesn't suck"
HOMEPAGE="https://github.com/kovidgoyal/rapydscript-ng"

LICENSE="BSD"
SLOT="0"

BDEPEND+=" net-libs/nodejs"
RDEPEND="net-libs/nodejs"

maint_pkg_create() {
	cd "${S}" || die

	edo npm install --omit=optional

	local ver=$(git describe)
	ver=${ver#v}
	local tar="${T}/rapydscript-ng-node_modules-${ver}.tar.xz"

	bsdtar -s "#^#${PN}-node_modules-${ver}/#S" -caf "${tar}" package-lock.json node_modules/ || die
	einfo "Packaged tar now available:"
	einfo "$(du -b "${tar}")"
}

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		maint_pkg_create
	else
		unpack ${A}
		cp -r "${WORKDIR}"/${PN}-node_modules-${PV}/{node_modules,package-lock.json} "${S}" || die
	fi
}

src_compile() {
	edo bin/rapydscript self --complete
	rm -r release/ || die
	mv dev/ release/ || die
}

src_test() {
	edo bin/rapydscript test
}

src_install() {
	local modulesdir=/usr/$(get_libdir)/node_modules/rapydscript-ng

	insinto "${modulesdir}"
	doins -r *

	fperms +x "${modulesdir}"/bin/rapydscript
	dosym -r "${modulesdir}"/bin/rapydscript /usr/bin/rapydscript
}
