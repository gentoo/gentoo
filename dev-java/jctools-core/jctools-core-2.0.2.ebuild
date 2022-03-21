# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/JCTools/JCTools/archive/refs/tags/v2.0.2.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jctools-core-2.0.2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jctools:jctools-core:2.0.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Concurrency Tools Core Library"
HOMEPAGE="https://jctools.github.io/JCTools/"
SRC_URI="https://github.com/JCTools/JCTools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.12 -> >=dev-java/junit-4.13.2:4
# test? org.hamcrest:hamcrest-all:1.3 -> !!!artifactId-not-found!!!

DEPEND=">=virtual/jdk-1.8:*
	test? ( dev-java/hamcrest-library:1.3 )"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=(
	../{LICENSE,{README,RELEASE-NOTES}.md}
	../resources/'1977 - Lamport - Concurrent Reading and Writing.pdf'
	../resources/'2010 - Pisa - SPSC Queues on Shared Cache Multi-Core Systems.pdf'
	../resources/'2011 - Dice - MultiLane - A Concurrent Blocking Multiset.pdf'
	../resources/'2011 - Technion - CAFE - Scalable Task Pools with Adjustable Fairness and Contention.pdf'
	../resources/'2012 - Junchang- BQueue- Efﬁcient and Practical Queuing.pdf'
	../resources/'2012 - Salzburg - Fast and Scalable k-FIFO Queues.pdf'
	../resources/'2012 - Technion - SALSA - NUMA-aware Algorithm for Producer-Consumer Pools.pdf'
	../resources/'2013 - Afek - Fast Concurrent Queues for x86 Processors.pdf'
	../resources/'2013 - Salzburg - Distributed Queues in Shared Memory.pdf'
	../resources/'2014 - Afek - Fence-Free Work Stealing on Bounded TSO Processors.pdf'
)

S="${WORKDIR}/JCTools-${PV}/jctools-core"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,hamcrest-library-1.3"
JAVA_TEST_SRC_DIR="src/test/java"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
