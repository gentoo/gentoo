# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: clutter.eclass
# @MAINTAINER:
# GNOME Herd <gnome@gentoo.org>
# @AUTHOR:
# Nirbheek Chauhan <nirbheek@gentoo.org>
# @BLURB: Sets SRC_URI, LICENSE, etc and exports src_install

inherit versionator

HOMEPAGE="http://www.clutter-project.org/"

RV=($(get_version_components))
SRC_URI="http://www.clutter-project.org/sources/${PN}/${RV[0]}.${RV[1]}/${P}.tar.bz2"

# All official clutter packages use LGPL-2.1 or later
LICENSE="${LICENSE:-LGPL-2.1+}"

# This will be used by all clutter packages
DEPEND="virtual/pkgconfig"

# @ECLASS-VARIABLE: CLUTTER_LA_PUNT
# @DESCRIPTION:
# Set to anything except 'no' to remove *all* .la files before installing.
# Not to be used without due consideration, sometimes .la files *are* needed.
CLUTTER_LA_PUNT="${CLUTTER_LA_PUNT:-"no"}"

# @ECLASS-VARIABLE: DOCS
# @DESCRIPTION:
# This variable holds relative paths of files to be dodoc-ed.
# By default, it contains the standard list of autotools doc files
DOCS="${DOCS:-AUTHORS ChangeLog NEWS README TODO}"

# @ECLASS-VARIABLE: EXAMPLES
# @DESCRIPTION:
# This variable holds relative paths of files to be added as examples when the
# "examples" USE-flag exists, and is switched on. Bash expressions can be used
# since the variable is eval-ed before substitution. Empty by default.
EXAMPLES="${EXAMPLES:-""}"

# @FUNCTION: clutter_src_install
# @DESCRIPTION:
# Runs emake install, dodoc, and installs examples
clutter_src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ${DOCS} || die "dodoc failed"

	# examples
	if has examples ${IUSE} && use examples; then
		insinto /usr/share/doc/${PF}/examples

		# We use eval to be able to use globs and other bash expressions
		for example in $(eval echo ${EXAMPLES}); do
			# If directory
			if [[ ${example: -1} == "/" ]]; then
				doins -r ${example} || die "doins ${example} failed!"
			else
				doins ${example} || die "doins ${example} failed!"
			fi
		done
	fi

	# Delete all .la files
	if [[ "${CLUTTER_LA_PUNT}" != "no" ]]; then
		find "${D}" -name '*.la' -exec rm -f '{}' + || die
	fi
}

EXPORT_FUNCTIONS src_install
