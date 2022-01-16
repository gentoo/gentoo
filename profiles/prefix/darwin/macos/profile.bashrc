# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

if [[ ${EBUILD_PHASE} == prepare ]]; then
	# workaround for Gnulib bug that affects multiple packages: gzip, wget,
	# nano, etc
	# https://lists.gnu.org/archive/html/bug-gnulib/2021-09/msg00053.html
	# https://bugs.gentoo.org/829847
	# https://bugs.gentoo.org/831026
	find "${S}" -name "config.h*" \
		| xargs grep -l "define _GL_INLINE static _GL_UNUSED" \
		| while read file
	do
		einfo "fixing gnulib inline bug in ${file#${S}/}"
		origfile="${file}".gnulib-fix.$$
		mv "${file}" "${origfile}"
		sed -e 's/define _GL_INLINE static _GL_UNUSED/define _GL_INLINE _GL_UNUSED static/' \
			-e 's/define _GL_EXTERN_INLINE static _GL_UNUSED/define _GL_EXTERN_INLINE _GL_UNUSED static/' \
			"${origfile}" > "${file}"
		touch -r "${origfile}" "${file}"
	done
fi

