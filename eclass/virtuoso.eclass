# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/virtuoso.eclass,v 1.15 2014/03/07 03:27:47 creffett Exp $

# @ECLASS: virtuoso.eclass
# @MAINTAINER:
# Maciej Mrozowski <reavertm@gentoo.org>
# Chris Reffett <creffett@gentoo.org>
#
# @BLURB: Provides splitting functionality for Virtuoso
# @DESCRIPTION:
# This eclass provides common code for splitting Virtuoso OpenSource database

case ${EAPI:-0} in
	2|3|4|5) : ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

inherit autotools multilib eutils

MY_P="virtuoso-opensource-${PV}"

case ${PV} in
	*9999*)
		ECVS_SERVER="virtuoso.cvs.sourceforge.net:/cvsroot/virtuoso"
		ECVS_PROJECT='virtuoso'
		SRC_URI=""
		inherit cvs
		;;
	*)
		# Use this variable to determine distribution method (live or tarball)
		TARBALL="${MY_P}.tar.gz"
		SRC_URI="mirror://sourceforge/virtuoso/${TARBALL} mirror://gentoo/VOS-genpatches-${PV}.tar.bz2"
		;;
esac

EXPORT_FUNCTIONS src_prepare src_configure

# Set some defaults
HOMEPAGE='http://virtuoso.openlinksw.com/wiki/main/Main/'
LICENSE='GPL-2'
SLOT='0'

DEPEND='
	>=sys-devel/libtool-2.2.6a
'
RDEPEND=''

S="${WORKDIR}/${MY_P}"

# @FUNCTION: virtuoso_src_prepare
# @DESCRIPTION:
# 1. Applies common release patches
# 2. Applies package-specific patches (from ${FILESDIR}/, PATCHES can be used)
# 3. Applies user patches from /etc/portage/patches/${CATEGORY}/${PN}/
# 4. Modifies makefiles for split build. Uses VOS_EXTRACT
# 5. eautoreconf
virtuoso_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	EPATCH_SUFFIX='patch' EPATCH_FORCE='yes' epatch
	pushd "${S}" >/dev/null
	[[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"

	debug-print "$FUNCNAME: applying user patches"
	epatch_user


	# @ECLASS-VARIABLE: VOS_EXTRACT
	# @DESCRIPTION:
	# Lists any subdirectories that are required to be extracted
	# and enabled in Makefile.am's for current package.
	if [[ -n ${VOS_EXTRACT} ]]; then
		# Comment out everything
		find . -name Makefile.am -exec \
			sed -e '/SUBDIRS\s*=/s/^/# DISABLED /g' -i {} + \
				|| die 'failed to disable subdirs'

		# Uncomment specified
		local path
		for path in ${VOS_EXTRACT}; do
			if [[ -d "${path}" ]]; then
				# Uncomment leaf
				if [[ -f "${path}"/Makefile.am ]]; then
					sed -e '/^# DISABLED \s*SUBDIRS\s*=/s/# DISABLED //g' \
						-i "${path}"/Makefile.am || die "failed to uncomment leaf in ${path}/Makefile.am"
				fi
				# Process remaining path elements
				while true; do
					local subdir=`basename "${path}"`
					path=`dirname "${path}"`
					if [[ -f "${path}"/Makefile.am ]]; then
						# Uncomment if necessary
						sed -e '/^# DISABLED \s*SUBDIRS\s*=/s/.*/SUBDIRS =/g' \
							-i "${path}"/Makefile.am
						# Append subdirs if not there already
						if [[ -z `sed -ne "/SUBDIRS\s*=.*${subdir}\b/p" "${path}"/Makefile.am` ]]; then
							sed -e "/^SUBDIRS\s*=/s|$| ${subdir}|" \
								-i "${path}"/Makefile.am || die "failed to append ${subdir}"
						fi
					fi
					[[ "${path}" = . ]] && break
				done
			fi
		done
	fi

	eautoreconf
}

# @FUNCTION: virtuoso_src_configure
# @DESCRIPTION:
# Runs ./configure with common and user options specified via myconf variable
virtuoso_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	# Override some variables to make tests work
	if [[ ${PN} != virtuoso-server ]]; then
		[[ ${EAPI} == 2 ]] && ! use prefix && EPREFIX=
		export ISQL="${EPREFIX}"/usr/bin/isql-v
		export SERVER="${EPREFIX}"/usr/bin/virtuoso-t
	fi

	econf \
		--with-layout=gentoo \
		--localstatedir="${EPREFIX}"/var \
		--enable-shared \
		--with-pthreads \
		--without-internal-zlib \
		${myconf}
}
