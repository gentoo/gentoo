# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Author: Michael Cummings <mcummings@gentoo.org>
# Maintained by the Perl herd <perl@gentoo.org>

# If the ebuild doesn't override this, ensure we do not depend on the perl subslot value
: ${GENTOO_DEPEND_ON_PERL_SUBSLOT:="no"}
inherit perl-module

# @FUNCTION: perl-app_src_prep
# @USAGE: perl-app_src_prep
# @DESCRIPTION:
# This is a wrapper function to perl-app_src_configure().
perl-app_src_prep() {
	perl-app_src_configure
}

# @FUNCTION: perl-app_src_configure
# @USAGE: perl-app_src_configure
# @DESCRIPTION:
# This is a wrapper function to perl-module_src_configure().
perl-app_src_configure() {
	perl-module_src_configure
}

# @FUNCTION: perl-app_src_compile
# @USAGE: perl-app_src_compile
# @DESCRIPTION:
# This is a wrapper function to perl-module_src_compile().
perl-app_src_compile() {
	has "${EAPI:-0}" 0 1 && perl-app_src_prep
	perl-module_src_compile
}
