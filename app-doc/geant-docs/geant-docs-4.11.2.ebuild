# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=V$(ver_cut 2-3)

DESCRIPTION="User documentation for Geant4 physics simulation toolkit"
HOMEPAGE="https://geant4.web.cern.ch/support/user_documentation"
SRC_DOC="https://geant4-userdoc.web.cern.ch/geant4-userdoc/UsersGuides"
SRC_URI="
	${SRC_DOC}/FAQ/BackupVersions/${MY_PV}/fo/BookFAQ.pdf
		-> BookFAQ-${PV}.pdf
	${SRC_DOC}/ForApplicationDeveloper/BackupVersions/${MY_PV}/fo/BookForApplicationDevelopers.pdf
		-> BookForApplicationDevelopers-${PV}.pdf
	${SRC_DOC}/ForToolkitDeveloper/BackupVersions/${MY_PV}/fo/BookForToolkitDevelopers.pdf
		-> BookForToolkitDevelopers-${PV}.pdf
	${SRC_DOC}/InstallationGuide/BackupVersions/${MY_PV}/fo/Geant4InstallationGuide.pdf
		-> Geant4InstallationGuide-${PV}.pdf
	${SRC_DOC}/IntroductionToGeant4/BackupVersions/${MY_PV}/fo/IntroductionToGeant4.pdf
		-> IntroductionToGeant4-${PV}.pdf
	${SRC_DOC}/PhysicsListGuide/BackupVersions/${MY_PV}/fo/PhysicsListGuide.pdf
		-> PhysicsListGuide-${PV}.pdf
	${SRC_DOC}/PhysicsReferenceManual/BackupVersions/${MY_PV}/fo/PhysicsReferenceManual.pdf
		-> PhysicsReferenceManual-${PV}.pdf
"

S="${DISTDIR}"

LICENSE="geant4"
SLOT="4"
KEYWORDS="amd64 ~riscv x86 ~amd64-linux ~x86-linux"

src_unpack() {
		: # empty, nothing to unpack
}

src_install() {
	local doc
	for doc in *.pdf; do
		newdoc ${doc} ${doc/-${PV}};
	done
}
