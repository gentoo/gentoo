# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: xemacs-packages.eclass
# @MAINTAINER:
# xemacs@gentoo.org
# @BLURB: Eclass to support elisp packages distributed by XEmacs.
# @DESCRIPTION:
# This eclass supports ebuilds for packages distributed by XEmacs.

# @ECLASS-VARIABLE: XEMACS_PKG_CAT
# @REQUIRED
# @DESCRIPTION:
# The package category that the package is in. Can be either standard,
# mule, or contrib.

# @ECLASS-VARIABLE: XEMACS_EXPERIMENTAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set then the package is downloaded from the experimental packages
# repository, which is the staging area for packages upstream. Packages
# in the experimental repository are auto-generated from XEmacs VCS, so
# they may not be well-tested.

EXPORT_FUNCTIONS src_unpack src_install

RDEPEND="app-editors/xemacs"
S="${WORKDIR}"

: ${HOMEPAGE:="http://xemacs.org/"}
: ${LICENSE:="GPL-2+"}

# Backwards compatibility code, to be removed after 2017-05-03
: ${XEMACS_PKG_CAT:=${PKG_CAT}}
: ${XEMACS_EXPERIMENTAL:=${EXPERIMENTAL}}

if [[ -n ${XEMACS_EXPERIMENTAL} ]]; then
	: ${SRC_URI:="http://ftp.xemacs.org/pub/xemacs/beta/experimental/packages/${P}-pkg.tar.gz"}
else
	: ${SRC_URI:="http://ftp.xemacs.org/pub/xemacs/packages/${P}-pkg.tar.gz"}
fi

xemacs-packages_src_unpack() { :; }

xemacs-packages_src_install() {
	local install_dir

	case ${XEMACS_PKG_CAT} in
		standard) install_dir="/usr/lib/xemacs/xemacs-packages" ;;
		mule)     install_dir="/usr/lib/xemacs/mule-packages"   ;;
		contrib)  install_dir="/usr/lib/xemacs/site-packages"   ;;
		*) die "Unsupported package category in XEMACS_PKG_CAT (or unset)" ;;
	esac
	debug-print "install_dir is ${install_dir}"

	dodir "${install_dir}"
	cd "${D}${EPREFIX}${install_dir}" || die
	unpack ${A}
}
