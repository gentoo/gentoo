# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="0"
inherit kernel-2 subversion git-r3
detect_version
detect_arch

KEYWORDS=""
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches"
IUSE="deblob experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="https://www.kernel.org/pub/linux/kernel/v3.x/linux-${KV_MAJOR}.${KV_MINOR}.tar.xz ${ARCH_URI}"
ESVN_REPO_URI="svn://anonsvn.gentoo.org/linux-patches/genpatches-2.6/trunk/${KV_MAJOR}.${KV_MINOR}"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
	http://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git"

S="${WORKDIR}/linux-${KV_MAJOR}.${KV_MINOR}.9999"

UNIPATCH_DOCS="${UNIPATCH_DOCS} ../work/0000_README"

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}

src_unpack() {
	unpack ${A}

	mv "${WORKDIR}/linux-${KV_MAJOR}.${KV_MINOR}" "${S}" || die
	cd "${S}" || die

	subversion_src_unpack
	EGIT_CHECKOUT_DIR="${WORKDIR}/stable-queue" git-r3_src_unpack
}

src_prepare() {
	# First do previous versions, ...
	for p in 1[0123]*.patch* ; do
		UNIPATCH_LIST+=" ${p}"
	done
	unipatch "${UNIPATCH_LIST}"

	# ... then do the stable queue, as they are not ordered by name; we apply them one by one ...
	local patch_dir="${WORKDIR}/stable-queue/queue-${KV_MAJOR}.${KV_MINOR}"
	for p in $(cat ${patch_dir}/series | tr '\n' ' ') ; do
		if [[ -f "${patch_dir}/${p}" ]] ; then
			UNIPATCH_LIST="${patch_dir}/${p}"
			unipatch "${UNIPATCH_LIST}"
		fi
	done

	# ... and finally do the rest of the genpatches.
	UNIPATCH_LIST=""
	for p in 1[4-9]*.patch* [2-4]*.patch* 50*.patch* ; do
		if ! use experimental ; then
			[[ ${p} == "50"*_*.patch* ]] && continue
		fi
		UNIPATCH_LIST+=" ${p}"
	done
	unipatch "${UNIPATCH_LIST}"

	rm *.patch* || die
	mv 0000_README ../ || die
}
