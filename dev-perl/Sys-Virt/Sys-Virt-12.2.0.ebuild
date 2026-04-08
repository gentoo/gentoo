# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Packages which get releases together:
# app-emacs/nxml-libvirt-schemas
# dev-python/libvirt-python
# dev-perl/Sys-Virt
# app-emulation/libvirt
# Please bump them together!

DIST_AUTHOR=DANBERR
DIST_VERSION=v${PV}
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="API for using the libvirt library from Perl"

SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	>=app-emulation/libvirt-${PV}
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/CPAN-Changes
		dev-perl/Test-More-UTF8
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		dev-perl/XML-XPath
	)"
DEPEND="
	>=app-emulation/libvirt-${PV}
"
