# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Git post-receive web hook notifier in Python."
HOMEPAGE="https://github.com/metajack/notify-webhook"
COMMIT='1ff39853e59bb0ee37c4783da8dcf3ea14cef53f'
PATCH_COMMIT='BCLibCoop:ee038b53a48e70d9e69c86386c39b7f24736d07e'
PATCH_DELTA="${COMMIT:0:7}...${PATCH_COMMIT:0:17}"
PATCH_NAME="${P}-${PATCH_DELTA}.patch"
SRC_URI="https://github.com/metajack/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/metajack/notify-webhook/compare/${PATCH_DELTA}.patch -> ${PATCH_NAME}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/simplejson"
DEPEND="${RDEPEND}
		dev-util/patchutils"

MY_P="${PN}-${COMMIT}"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${P}.tar.gz
}

# Yes, this is some creative patch mangling, to avoid a manually created
# distfile. epatch's dryrun fails on a sequence of changes that depend on each
# other, so we can clean up the patch to actually pass that check.
src_prepare() {
	cd "${T}"
	cp "${DISTDIR}/${PATCH_NAME}" diff
	p="newdiff"
	>$p # Make an empty file to work in
	splitdiff -a -p 1 diff # split out the patches
	# combine them to a single patch
	for f in diff.part*.patch ; do
		combinediff -p 1 $p $f >$p.new && mv $p.new $p
	done

	# Now apply it, and dry-run will pass too!
	cd "${S}"
	EPATCH_OPTS="-p1" epatch "${T}"/newdiff
}

src_install() {
	dodoc *markdown
	exeinto /usr/libexec/githook/$PN/
	doexe notify-webhook.py
}
