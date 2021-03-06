// Licensed to Cloudera, Inc. under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  Cloudera, Inc. licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

DataDefinition
 : RefreshStatement
 | InvalidateStatement
 | ComputeStatsStatement
 ;

DataDefinition_EDIT
 : RefreshStatement_EDIT
 | InvalidateStatement_EDIT
 | ComputeStatsStatement_EDIT
 ;

RefreshStatement
 : 'REFRESH' SchemaQualifiedTableIdentifier OptionalPartitionSpec
   {
     parser.addTablePrimary($2);
   }
 | 'REFRESH' 'FUNCTIONS' DatabaseIdentifier
   {
     parser.addDatabaseLocation(@3, [{ name: $3 }]);
   }
 | 'REFRESH' 'AUTHORIZATION'
 ;

RefreshStatement_EDIT
 : 'REFRESH' 'CURSOR'
   {
     parser.suggestTables();
     parser.suggestDatabases({ appendDot: true });
     parser.suggestKeywords(['AUTHORIZATION', 'FUNCTIONS']);
   }
 | 'REFRESH' SchemaQualifiedTableIdentifier_EDIT OptionalPartitionSpec
 | 'REFRESH' SchemaQualifiedTableIdentifier OptionalPartitionSpec 'CURSOR'
   {
     parser.addTablePrimary($2);
     if (!$3) {
       parser.suggestKeywords(['PARTITION']);
     }
   }
 | 'REFRESH' SchemaQualifiedTableIdentifier OptionalPartitionSpec_EDIT
 | 'REFRESH' 'FUNCTIONS' 'CURSOR'
   {
     parser.suggestDatabases();
   }
 ;

InvalidateStatement
 : 'INVALIDATE' 'METADATA'
 | 'INVALIDATE' 'METADATA' SchemaQualifiedTableIdentifier
   {
     parser.addTablePrimary($3);
   }
 ;

InvalidateStatement_EDIT
 : 'INVALIDATE' 'CURSOR'
   {
     parser.suggestKeywords(['METADATA']);
   }
 | 'INVALIDATE' 'METADATA' 'CURSOR'
   {
     parser.suggestTables();
     parser.suggestDatabases({ appendDot: true });
   }
 | 'INVALIDATE' 'METADATA' SchemaQualifiedTableIdentifier_EDIT
 | 'INVALIDATE' 'CURSOR' SchemaQualifiedTableIdentifier
   {
     parser.addTablePrimary($3);
     parser.suggestKeywords(['METADATA']);
   }
 ;

ComputeStatsStatement
 : 'COMPUTE' 'STATS' SchemaQualifiedTableIdentifier OptionalParenthesizedColumnList OptionalTableSample
   {
     parser.addTablePrimary($3);
   }
 | 'COMPUTE' 'INCREMENTAL' 'STATS' SchemaQualifiedTableIdentifier OptionalPartitionSpec
   {
     parser.addTablePrimary($4);
   }
 ;

ComputeStatsStatement_EDIT
 : 'COMPUTE' 'CURSOR'
   {
     parser.suggestKeywords(['STATS', 'INCREMENTAL STATS']);
   }
 | 'COMPUTE' 'STATS' 'CURSOR'
   {
     parser.suggestTables();
     parser.suggestDatabases({ appendDot: true });
   }
 | 'COMPUTE' 'STATS' SchemaQualifiedTableIdentifier_EDIT
 | 'COMPUTE' 'CURSOR' SchemaQualifiedTableIdentifier OptionalPartitionSpec
   {
     parser.addTablePrimary($3);
     parser.suggestKeywords(['STATS', 'INCREMENTAL STATS']);
   }
 | 'COMPUTE' 'STATS' SchemaQualifiedTableIdentifier OptionalParenthesizedColumnList OptionalTableSample 'CURSOR'
   {
     parser.addTablePrimary($3);
     if (!$5) {
       parser.suggestKeywords(['TABLESAMPLE']);
     } else if ($5.suggestKeywords) {
       parser.suggestKeywords($5.suggestKeywords);
     }
   }
 | 'COMPUTE' 'STATS' SchemaQualifiedTableIdentifier ParenthesizedColumnList_EDIT OptionalTableSample
   {
     parser.addTablePrimary($3);
   }
 | 'COMPUTE' 'STATS' SchemaQualifiedTableIdentifier OptionalParenthesizedColumnList TableSample_EDIT
   {
     parser.addTablePrimary($3);
   }
 | 'COMPUTE' 'CURSOR' 'STATS' SchemaQualifiedTableIdentifier OptionalPartitionSpec
   {
     parser.addTablePrimary($4);
     parser.suggestKeywords(['INCREMENTAL']);
   }
 | 'COMPUTE' 'INCREMENTAL' 'CURSOR'
   {
     parser.suggestKeywords(['STATS']);
   }
 | 'COMPUTE' 'INCREMENTAL' 'CURSOR' SchemaQualifiedTableIdentifier OptionalPartitionSpec
   {
     parser.addTablePrimary($4);
     parser.suggestKeywords(['STATS']);
   }
 | 'COMPUTE' 'INCREMENTAL' 'STATS' 'CURSOR'
   {
     parser.suggestTables();
     parser.suggestDatabases({ appendDot: true });
   }
 | 'COMPUTE' 'INCREMENTAL' 'STATS' SchemaQualifiedTableIdentifier_EDIT OptionalPartitionSpec
 | 'COMPUTE' 'INCREMENTAL' 'STATS' SchemaQualifiedTableIdentifier 'CURSOR' OptionalPartitionSpec
   {
     parser.addTablePrimary($4);
     if (!$6) {
       parser.suggestKeywords(['PARTITION']);
     }
   }
 | 'COMPUTE' 'INCREMENTAL' 'STATS' SchemaQualifiedTableIdentifier PartitionSpec_EDIT
   {
     parser.addTablePrimary($4);
   }
 ;
