# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: xemacs-packages-r1.eclass
# @MAINTAINER:
# xemacs@gentoo.org
# @BLURB: Eclass to support elisp packages distributed by XEmacs.
# @DESCRIPTION:
# This eclass supports ebuilds for packages distributed by XEmacs.
# Ebuilds have to support EAPI 6 at a minimum.

case ${EAPI:-0} in
	[0-5])
		die "xemacs-packages-r1.eclass is banned in EAPI ${EAPI:-0}"
		;;
	6)
		;;
	*)
		die "Unknown EAPI ${EAPI}"
		;;
esac

EXPORT_FUNCTIONS src_install

if [[ ! ${_XEMACS_PACKAGES_R1} ]]; then

RDEPEND="app-editors/xemacs"
DEPEND="${DEPEND}"

HOMEPAGE="http://xemacs.org/"
LICENSE="GPL-2"

S="${WORKDIR}"

# @ECLASS-VARIABLE: XEMACS_PKG_CAT
# @REQUIRED
# @DESCRIPTION:
# The package category that the package is in. Can be either standard,
# mule, or contrib. Has to be defined before inheriting the eclass.
# Take care not to modify this variable later on.

[[ ${XEMACS_PKG_CAT} ]] || die "XEMACS_PKG_CAT was not defined before inheriting xemacs-packages-r1.eclass"
case ${XEMACS_PKG_CAT} in
	standard|mule|contrib)
		;;
	*)
		die "Unsupported package category in XEMACS_PKG_CAT"
		;;
esac
readonly _XEMACS_INITIAL_PKG_CAT=${XEMACS_PKG_CAT}

# @ECLASS-VARIABLE: XEMACS_EXPERIMENTAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set then the package is downloaded from the experimental packages
# repository, which is the staging area for packages upstream. Packages
# in the experimental repository are auto-generated from XEmacs VCS, so
# they may not be well-tested. Has to be defined before inheriting the
# eclass.

if [[ -n ${XEMACS_EXPERIMENTAL} ]]; then
	SRC_URI="http://ftp.xemacs.org/pub/xemacs/beta/experimental/packages/${P}-pkg.tar.gz"
else
	SRC_URI="http://ftp.xemacs.org/pub/xemacs/packages/${P}-pkg.tar.gz"
fi

# @FUNCTION: xemacs-packages-r1_src_install
# @DESCRIPTION:
# xemacs-packages-r1_src_install install the package in a Prefix-aware
# manner.
xemacs-packages-r1_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${_XEMACS_INITIAL_PKG_CAT} != ${XEMACS_PKG_CAT} ]] && \
		die "XEMACS_PKG_CAT has been changed between the initial definition and src_install"

	local xemacs_subdir
	case ${XEMACS_PKG_CAT} in
		standard)
			xemacs_subdir=xemacs-packages
			;;
		mule)
			xemacs_subdir=mule-packages
			;;
		contrib)
			xemacs_subdir=site-packages
			;;
	esac
	debug-print "XEmacs package install dir = /usr/lib/xemacs/${xemacs_subdir}"

	insinto /usr/lib/xemacs/${xemacs_subdir}
	doins -r .
}

_XEMACS_PACKAGES_R1=1
fi
