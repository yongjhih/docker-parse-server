var graphql = require('graphql')
var GraphQLSchema = graphql.GraphQLSchema
var GraphQLObjectType = graphql.GraphQLObjectType
var GraphQLString = graphql.GraphQLString

module.exports = new GraphQLSchema({
  query: new GraphQLObjectType({
    name: 'RootQueryType',
    fields: {
      hello: {
        type: GraphQLString,
        resolve() {
          return 'world';
        }
      }
    }
  })
});
