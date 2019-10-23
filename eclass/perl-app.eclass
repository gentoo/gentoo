# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @DEAD
# This eclass is dead and all its consumers have been removed from
# the tree.
# Please use perl-module.eclass if you need phase functions, and
# perl-functions.eclass if you don't.
# In overlays, perl-app.eclass usage can be replaced by
# perl-module.eclass without further changes.
# Bug 637836.  Removal in 14 days.

# Author: Michael Cummings <mcummings@gentoo.org>
# Maintained by the Perl herd <perl@gentoo.org>
# @SUPPORTED_EAPIS: 5

# If the ebuild doesn't override this, ensure we do not depend on the perl subslot value
: ${GENTOO_DEPEND_ON_PERL_SUBSLOT:="no"}
inherit perl-module

case "${EAPI:-0}" in
	5)
		;;
	6)
		die "EAPI=${EAPI} is not supported by perl-app.eclass. Please use perl-module.eclass instead."
		;;
	*)
		die "EAPI=${EAPI} is not supported by perl-app.eclass"
		;;
esac

# @FUNCTION: perl-app_src_prep
# @DESCRIPTION:
# This is a wrapper function to perl-app_src_configure().
perl-app_src_prep() {
	perl-app_src_configure
}

# @FUNCTION: perl-app_src_configure
# @DESCRIPTION:
# This is a wrapper function to perl-module_src_configure().
perl-app_src_configure() {
	perl-module_src_configure
}

# @FUNCTION: perl-app_src_compile
# @DESCRIPTION:
# This is a wrapper function to perl-module_src_compile().
perl-app_src_compile() {
	has "${EAPI:-0}" 0 1 && perl-app_src_prep
	perl-module_src_compile
}
