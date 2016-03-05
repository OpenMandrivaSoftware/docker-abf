#!/bin/bash
mkdir /repoclosure-report
pushd /repoclosure-report
urpm-repoclosure -profile /tmp/profile.xml
popd
