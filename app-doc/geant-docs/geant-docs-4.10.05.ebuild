# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="User documentation for Geant4 physics simulation toolkit"
HOMEPAGE="https://geant4.web.cern.ch/support/user_documentation"
SRC_DOC="http://cern.ch/geant4-userdoc/UsersGuides"
SRC_URI="
	${SRC_DOC}/InstallationGuide/fo/Geant4InstallationGuide.pdf -> BookInstalGuide-${PV}.pdf
	${SRC_DOC}/ForApplicationDeveloper/fo/BookForApplicationDevelopers.pdf -> BookForAppliDev-${PV}.pdf
	${SRC_DOC}/ForToolkitDeveloper/fo/BookForToolkitDevelopers.pdf -> BookForToolDev-${PV}.pdf
	${SRC_DOC}/PhysicsReferenceManual/fo/PhysicsReferenceManual.pdf -> PhysicsReferenceManual-${PV}.pdf
"

LICENSE="geant4"
SLOT="4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${DISTDIR}"

src_install() {
	local d
	for d in *pdf; do newdoc ${d} ${d/-${PV}}; done
	echo GEANT_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}" >> 99geant-doc || die
	doenvd 99geant-doc
}
