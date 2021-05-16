# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Build lists of van der Waals clashes from an input PDB file"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/index.php"
SRC_URI="mirror://gentoo/molprobity-${PV}.tgz"

LICENSE="richardson"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=sci-chemistry/cluster-1.3.081231-r1
	sci-chemistry/probe"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	default
	sed \
		-e 's: cluster : molprobity-cluster :g' \
		-i molprobity3/bin/clashlist || die
}

src_install() {
	dobin molprobity3/bin/clashlist
}
