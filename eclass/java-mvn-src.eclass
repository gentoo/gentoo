# Copyright 2004-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: java-mvn-src.eclass
# @MAINTAINER:
# java@gentoo.org
# @AUTHOR:
# Java maintainers (java@gentoo.org)
# @BLURB: Eclass for Java packages from bare sources exported by Maven
# @DESCRIPTION:
# This class is intended to build pure Java packages from the sources exported
# from the source:jar goal of Maven 2. These archives contain bare Java source
# files, with no build instructions or additional resource files. They are
# unsuitable for packages that require resources besides compiled class files.
# The benefit is that for artifacts developed with Maven, these source files
# are often released together with binary packages, whereas the full build
# environment might be contained in some revision control system or not
# available at all.

inherit java-pkg-simple

# @ECLASS-VARIABLE: GROUP_ID
# @DESCRIPTION:
# The groupId of the artifact, in dotted notation. Default value is ${PN}.
: ${GROUP_ID:=${PN}}

# @ECLASS-VARIABLE: ARTIFACT_ID
# @DESCRIPTION:
# The artifactId of the artifact. Default value is ${PN}.
: ${ARTIFACT_ID:=${PN}}

# @ECLASS-VARIABLE: MAVEN2_REPOSITORIES
# @DESCRIPTION:
# The repositories to search for the artifacts. Must follow Maven2 layout.
# Default value is the following string:
# "http://repo2.maven.org/maven2 http://download.java.net/maven/2"
: ${MAVEN2_REPOSITORIES:="http://repo2.maven.org/maven2 http://download.java.net/maven/2"}

# @ECLASS-VARIABLE: RELATIVE_SRC_URI
# @DESCRIPTION:
# The path of the source artifact relative to the root of the repository.
# Will be set by the eclass to follow Maven 2 repository layout.
RELATIVE_SRC_URI=${GROUP_ID//./\/}/${ARTIFACT_ID}/${PV}/${ARTIFACT_ID}-${PV}-sources.jar

# Look for source jar in all listed repositories
for repo in ${MAVEN2_REPOSITORIES}; do
	SRC_URI="${SRC_URI} ${repo}/${RELATIVE_SRC_URI}"
done
unset repo
