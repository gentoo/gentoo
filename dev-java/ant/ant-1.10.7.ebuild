# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Java-based build tool similar to 'make' that uses XML configuration files"
HOMEPAGE="https://ant.apache.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="X +antlr +bcel +bsf +commonslogging +commonsnet jai +javamail +jdepend jmf
	+jsch +junit +junit4 +junitlauncher +log4j +oro +regexp +resolver swing testutil xz"

DEPEND="~dev-java/ant-core-${PV}"

RDEPEND="${DEPEND}
	~dev-java/ant-core-${PV}
	~dev-java/ant-junit-${PV}
	~dev-java/ant-apache-xalan2-${PV}
	antlr? ( ~dev-java/ant-antlr-${PV} )
	bcel? ( ~dev-java/ant-apache-bcel-${PV} )
	bsf? ( ~dev-java/ant-apache-bsf-${PV} )
	commonslogging? ( ~dev-java/ant-commons-logging-${PV} )
	commonsnet? ( ~dev-java/ant-commons-net-${PV} )
	jai? ( ~dev-java/ant-jai-${PV} )
	javamail? ( ~dev-java/ant-javamail-${PV} )
	jdepend? ( ~dev-java/ant-jdepend-${PV} )
	jmf? ( ~dev-java/ant-jmf-${PV} )
	jsch? ( ~dev-java/ant-jsch-${PV} )
	junit? ( ~dev-java/ant-junit-${PV} )
	junit4? ( ~dev-java/ant-junit4-${PV} )
	junitlauncher? ( ~dev-java/ant-junitlauncher-${PV} )
	log4j? ( ~dev-java/ant-apache-log4j-${PV} )
	oro? ( ~dev-java/ant-apache-oro-${PV} )
	regexp? ( ~dev-java/ant-apache-regexp-${PV} )
	resolver? ( ~dev-java/ant-apache-resolver-${PV} )
	swing? ( ~dev-java/ant-swing-${PV} )
	testutil? ( ~dev-java/ant-testutil-${PV} )
	X? ( ~dev-java/ant-swing-${PV} )
	xz? ( ~dev-java/ant-xz-${PV} )
"

S="${WORKDIR}"

src_compile() { :; }
