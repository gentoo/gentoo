# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gdesklets.eclass
# @MAINTAINER:
# gdesklets@gentoo.org
# @AUTHOR:
# Original author: Joe Sapp <nixphoeni@gentoo.org>
# Original author: Mike Gardiner <obz@gentoo.org>
# @BLURB: Installation functions for Desklets and Controls supported by gDesklets
# @DESCRIPTION:
# The gdesklets eclass provides a simple way to create ebuilds for
# globally installing desktop applets ("Desklets") and supporting code
# ("Controls") used in the gDesklets framework (provided by
# gnome-extra/gdesklets-core)
#
# This eclass assumes a package following the instructions at
# http://gdesklets.de/index.php?q=node/2 .  Specifically, the package
# should be a Desklet or Control ONLY (and *not* a Sensor).  You
# technically could have an ebuild that works around this limitation,
# but no new packages should be added to the tree that do this (mainly
# for ease of maintenance).

# @ECLASS-VARIABLE: DESKLET_NAME
# @DESCRIPTION:
# *Optional*  The name of the Desklet, if the package is one. The
# default is to assume a Desklet with the name being ${PN} without the
# "desklet-" prefix.

# @ECLASS-VARIABLE: CONTROL_NAME
# @DESCRIPTION:
# *Optional*  The name of the Control, if the package is one.

# @ECLASS-VARIABLE: DOCS
# @DESCRIPTION:
# Anything (like a README) that should be dodoc'd.

# @ECLASS-VARIABLE: SLOT
# @DESCRIPTION:
# Set only if the package is a Control and it provides a different
# interface (i.e. expands to a different install directory) than a
# previous version.

inherit eutils multilib python

if [[ -n "${CONTROL_NAME}" ]]; then
	debug-print "Looking for a Control named \"${CONTROL_NAME}\""
	MY_PN="${CONTROL_NAME}"
	SRC_URI="http://gdesklets.de/files/controls/${MY_PN}/${MY_PN}-${PV}.tar.gz"
	unset DESKLET_NAME
else # [[ -n "${DESKLET_NAME}" ]]; then
	# Assume an unset DESKLET_NAME means the name is ${PN} without
	# the "desklet-" prefix
	[[ -z "${DESKLET_NAME}" ]] && DESKLET_NAME="${PN#desklet-}"
	debug-print "Looking for a Desklet named \"${DESKLET_NAME}\""
	MY_PN="${DESKLET_NAME}"
	SRC_URI="http://gdesklets.de/files/desklets/${MY_PN}/${MY_PN}-${PV}.tar.gz"
fi

MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_PN}"

SLOT="0"
# Ebuild writer shouldn't need to touch these (except maybe RDEPEND)
IUSE=""
RDEPEND=">=gnome-extra/gdesklets-core-0.36.1-r3"

GDESKLETS_INST_DIR="${ROOT}usr/$(get_libdir)/gdesklets"

# @FUNCTION: gdesklets_src_install
# @DESCRIPTION:
# Installs a Desklet or Control depending on which is set of
# CONTROL_NAME or DESKLET_NAME
gdesklets_src_install() {

	debug-print-function $FUNCNAME $*

	# Disable compilation of included python modules (for Controls)
	python_disable_pyc

	# Avoid sandbox violations caused by misbehaving packages (bug #128289)
	addwrite "${ROOT}/root/.gnome2"

	# Both Displays and Controls only need to be readable
	insopts -m0744

	debug-print-section docs_install

	# Install some docs if so requested (and then delete them so they
	# don't get copied into the installation directory)
	[[ -n "${DOCS}" ]] && dodoc ${DOCS} && \
		rm -f ${DOCS} \
		debug-print "Installed and deleted ${DOCS}"
	# LICENSE doesn't need to get installed if it exists
	find . -name LICENSE -delete

	if [[ -n "${DESKLET_NAME}" ]]; then

		debug-print-section display_install

		# Base installation directory for displays from this desklet
		INSDIR="${GDESKLETS_INST_DIR}/Displays/${DESKLET_NAME}"

		debug-print "Installing into ${INSDIR}"
		debug-print "Exiting Display-specific installation code"

	elif [[ -n "${CONTROL_NAME}" ]]; then

		debug-print-section control_install

		# Unique name for this Control and its interface
		CTRL_DIRNAME=$( "${GDESKLETS_INST_DIR}/gdesklets-control-getid" `pwd` 2> /dev/null )
		einfo "Installing Control ${CTRL_DIRNAME}"

		# Base installation directory for this Control
		INSDIR="${GDESKLETS_INST_DIR}/Controls/${CTRL_DIRNAME}"
		debug-print "Installing into ${INSDIR}"

		# Mercilessly delete all existing compiled code
		find . -iname '*.py[co]' -delete

		debug-print "Exiting Control-specific installation code"

	else
		die "nothing to install, is the ebuild written correctly?"
	fi

	debug-print-section common_install

	# Create the proper subdirectory in the global Controls or
	# Displays directory
	dodir "${INSDIR}"
	insinto "${INSDIR}"
	doins -r *

}

# @FUNCTION: gdesklets_pkg_postinst
# @DESCRIPTION:
# Marks the Control for rebuilding on Python version change and
# compiles the Python code or display a useful message to the user,
# depending on which of CONTROL_NAME or DESKLET_NAME is set.
gdesklets_pkg_postinst() {

	# The only time compilation of python modules should occur is
	# for Controls, since Displays are run from inside the sandbox
	# (and therefore can't be compiled).
	if [[ -n "${CONTROL_NAME}" ]]; then

		CTRL_DIRNAME=$( "${GDESKLETS_INST_DIR}/gdesklets-control-getid" `pwd` 2> /dev/null )
		python_need_rebuild
		python_mod_optimize "${GDESKLETS_INST_DIR}/Controls/${CTRL_DIRNAME}"

	else

		einfo "Each user can now add this desklet to their desktop through the"
		einfo "gDesklets shell or the command line (.display files can be"
		einfo "found in ${GDESKLETS_INST_DIR}/Displays/${DESKLET_NAME})."

	fi

}

EXPORT_FUNCTIONS src_install pkg_postinst
