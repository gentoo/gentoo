# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# Original Author: Mike Doty <kingtaco@gentoo.org>
# Adapted from emul-libs.eclass
# Purpose: Providing a template for the app-emulation/emul-linux-* packages
#

inherit eutils multilib

case "${EAPI:-0}" in
	3|4|5)
		EXPORT_FUNCTIONS src_prepare src_install
		;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

DESCRIPTION="Provides precompiled 32bit libraries"
#HOMEPAGE="https://amd64.gentoo.org/emul/content.xml"
HOMEPAGE="https://dev.gentoo.org/~pacho/emul.html"
SRC_URI="https://dev.gentoo.org/~pacho/emul/${P}.tar.xz"

IUSE="+development"

RESTRICT="strip"
S=${WORKDIR}

QA_PREBUILT="*"

SLOT="0"

DEPEND=">=sys-apps/findutils-4.2.26"
RDEPEND=""

emul-linux-x86_src_prepare() {
	ALLOWED=${ALLOWED:-^${S}/etc/env.d}
	use development && ALLOWED="${ALLOWED}|/usr/lib32/pkgconfig"
	find "${S}" ! -type d ! '(' -name '*.so' -o -name '*.so.[0-9]*' -o -name '*.h' ')' | egrep -v "${ALLOWED}" | xargs -d $'\n' rm -f || die 'failed to remove everything but *.so*'
}

emul-linux-x86_src_install() {
	for dir in etc/env.d etc/revdep-rebuild ; do
		if [[ -d "${S}"/${dir} ]] ; then
			for f in "${S}"/${dir}/* ; do
				mv -f "$f"{,-emul}
			done
		fi
	done

	# remove void directories
	find "${S}" -depth -type d -print0 | xargs -0 rmdir 2&>/dev/null

	cp -pPR "${S}"/* "${ED}"/ || die "copying files failed!"

	# Do not hardcode lib32, bug #429726
	local x86_libdir=$(get_abi_LIBDIR x86)
	if [[ ${x86_libdir} != "lib32" ]] ; then
		ewarn "Moving lib32/ to ${x86_libdir}/; some libs might not work"
		mv "${D}"/usr/lib32 "${D}"/usr/${x86_libdir} || die
		if [[ -d ${D}/lib32 ]] ; then
			mv "${D}"/lib32 "${D}"/${x86_libdir} || die
		fi

		pushd "${D}"/usr/${x86_libdir} >/dev/null

		# Fix linker script paths.
		local ldscripts
		if ldscripts=( $(grep -ls '^GROUP.*/lib32/' *.so) ) ; then
			sed -i \
				-e "s:/lib32/:/${x86_libdir}/:" \
				"${ldscripts[@]}" || die
		fi

		# Rewrite symlinks (if need be).
		local sym tgt
		while read sym ; do
			tgt=$(readlink "${sym}")
			ln -sf "${tgt/lib32/${x86_libdir}}" "${sym}" || die
		done < <(find -xtype l)

		popd >/dev/null
	fi

	# Since header wrapping is added as part of gx86-multilib support,
	# all packages involved install their own copies of i686* headers
	# when built with abi_x86_32.
	if [[ -d "${D}"/usr/include ]] && use abi_x86_32; then
		rm -r "${D}"/usr/include || die
	fi
	# The same goes for ${CHOST}- multilib tool prefixing.
	if path_exists "${D}"/usr/bin/i686-pc-linux-gnu-* && use abi_x86_32; then
		rm "${D}"/usr/bin/i686-pc-linux-gnu-* || die
	fi
}
