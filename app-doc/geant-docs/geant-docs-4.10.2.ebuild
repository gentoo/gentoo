# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="User documentation for Geant4 physics simulation toolkit"
HOMEPAGE="https://geant4.web.cern.ch/geant4/support/userdocuments.shtml"
SRC_DOC="http://geant4.web.cern.ch/geant4/UserDocumentation/UsersGuides"
SRC_URI="
	${SRC_DOC}/InstallationGuide/fo/BookInstalGuide.pdf -> BookInstalGuide-${PV}.pdf
	${SRC_DOC}/ForApplicationDeveloper/fo/BookForAppliDev.pdf -> BookForAppliDev-${PV}.pdf
	${SRC_DOC}/ForToolkitDeveloper/fo/BookForToolDev.pdf -> BookForToolDev-${PV}.pdf
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
	echo GEANT_DOC_DIR="${EPREFIX%/}/usr/share/doc/${PF}" >> 99geant-doc
	doenvd 99geant-doc
}
